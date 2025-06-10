class UsersController < ApplicationController
  allow_unauthenticated_access

  def index
    @users = User.order(:username)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users.map { |user| json_resource(user) }, status: :ok }
    end
  end

  def show
    @user = resource_user

    if @user.blank?
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
      return
    end

    respond_to do |format|
      format.html { render :show }
      format.json { render json: json_resource(@user), status: :ok }
    end
  end

  private

    def resource_user
      return nil if resource_param.blank?
      User.find_by(username: resource_param)
    end

    def resource_param
      params.require(:username)
    end

    def json_resource(user)
      return nil if user.blank?

      {
        username: user.username,
        created_at: user.created_at
      }
    end
end
