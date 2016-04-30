class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.find_by id: params[:id]
    @activities = @user.activities.page params[:page]
  end
end
