class ActivityPub::OutboxesController < ApplicationController
  allow_unauthenticated_access

  def show
    head :ok
  end
end
