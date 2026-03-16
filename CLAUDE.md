# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BrillionBlog is a [value4value](https://value4value.info/about/) blogging system and simple CMS built on Rails 8.0. It implements ActivityPub for federation and WebFinger for user discovery, aiming to integrate with the Fediverse.

## Runtime

Uses `mise` for toolchain management: Ruby 3.4.4, Node 23. Environment variables are loaded from `.env` via mise.

## Common Commands

```bash
# Development server (runs web, tailwind watcher, and job worker)
bin/dev

# Run all tests
bin/rails test

# Run a single test file
bin/rails test test/models/user_test.rb

# Run a specific test by line number
bin/rails test test/models/user_test.rb:10

# Run system tests
bin/rails test:system

# Lint (RuboCop omakase style)
bin/rubocop

# Security analysis
bin/brakeman

# Database
bin/rails db:migrate
bin/rails db:schema:load  # faster for fresh setup
```

## Architecture

### Authentication
`ApplicationController` includes the `Authentication` concern (Rails 8 generated). Sessions are database-backed (`sessions` table). Passwords use `bcrypt` via `has_secure_password`. Most controllers use `allow_unauthenticated_access` since the app is primarily public-facing.

### ActivityPub / Fediverse Integration
The app implements the ActivityPub protocol for federation:
- **WebFinger** (`/.well-known/webfinger`): Resolves `acct:username` resources to user profile URLs, enabling actor discovery by other servers.
- **Actor endpoint** (`GET /users/:username` with `Accept: application/activity+json`): Returns JSON-LD describing the user as an ActivityPub `Person`, including their public key.
- **Inbox** (`POST /users/:username/inbox`): Receives federated activities (stub implementation).
- **Outbox** (`GET /users/:username/outbox`): Serves the user's activity stream (stub implementation).

### RSA Keypair Generation
When a `User` is created, `InitializeUserKeypairJob` is enqueued via Solid Queue to generate a 2048-bit RSA keypair asynchronously. The public/private keys are stored as PEM strings on the `users` table and used for ActivityPub HTTP Signatures.

### Background Jobs
Uses Solid Queue (database-backed). The job worker runs as a separate process (`bin/jobs`) via the `Procfile.dev`.

### Asset Pipeline
Uses Propshaft (not Sprockets) with importmap-rails for JavaScript. Tailwind CSS is compiled via `bin/rails tailwindcss:watch` in development.

### Database
SQLite with separate databases for the primary app, cache (Solid Cache), queue (Solid Queue), and cable (Solid Cable). Schemas for the secondary databases are in `db/cache_schema.rb`, `db/queue_schema.rb`, and `db/cable_schema.rb`.
