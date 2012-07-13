class UsersController < ApplicationController
  before_filter :authenticate_admin!, only: :index
  before_filter :authenticate_user!, only: :show
  load_and_authorize_resource

  def index
    @users = @users.paginate(:page => params[:page])
    fresh_when(etag: @users)
  end

  def show
    fresh_when(etag: @user)
  end
end
