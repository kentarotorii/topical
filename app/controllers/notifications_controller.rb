class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    #@notifications = Notification.where(user_id: current_user.id).where(read: false).order(created_at: :desc)
    @notifications = Notification.where(user_id: current_user.id).where("read=false OR created_at > ?",Date.today-7).order(created_at: :desc)
  end
end
