class ActivityPub::InboxesController < ApplicationController
  allow_unauthenticated_access

  def create
    head :ok
  end
end
