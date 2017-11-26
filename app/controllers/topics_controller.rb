class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:edit, :update, :destroy, :show]

  def index
    @topics = Topic.page(params[:page]).per(10).order('id DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def new
    if params[:back]
      @topic = Topic.new(topics_params)
    else
      @topic = Topic.new
    end
  end

  def create
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id

    if @topic.save
      redirect_to topics_path, notice: "トピックを作成しました！"
      #NoticeMailer.sendmail_topic(@topic).deliver
    else
      render 'new'
    end
  end

  def edit
    if @topic.user_id != current_user.id then
      redirect_to topics_path, notice: "トピックの投稿者しか編集できません"
    end
  end

  def update
    if @topic.update(topics_params)
      redirect_to topics_path, notice: "トピックを更新しました！"
    else
      render 'edit'
    end
  end

  def destroy
    if @topic.user_id != current_user.id then
      redirect_to topics_path, notice: "トピックの投稿者しか削除できません"
    end

    @topic.destroy
    redirect_to topics_path, notice: "トピックを削除しました！"
  end

  def confirm
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id
    render :new if @topic.invalid?
  end

  private
    def topics_params
      params.require(:topic).permit(:title, :content, :image, :image_cache, :remove_image,:id)
    end

    def set_topic
      #@topic = Topic.find(params[:id])
      @topic = Topic.find_by(:id => params[:id])
      if @topic.nil?
        redirect_to topics_path, notice: "トピックが存在しません"
      end
    end
end
