class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(comment_params)
    @topic = @comment.topic
    @notification = @comment.notifications.build(user_id: @topic.user.id)

    if @comment.topic.user_id == current_user.id
      @notification.read = true
    end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        format.js { render :index }
        unless @comment.topic.user_id == current_user.id
          Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したトピックにコメントが付きました'
          })
          Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'notification_created', {
            unread_counts: Notification.where(user_id: @comment.topic.user.id, read: false).count
          })
        end
      else
        format.html { render :new }
      end
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    @topic = @comment.topic
    respond_to do |format|
      @comment.destroy
      format.html { redirect_to topic_path(@topic), notice: 'コメントを削除しました。' }
      format.js { render :index }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @topic = @comment.topic
  end

  def update
    @comment = Comment.find(params[:id])
    @topic = @comment.topic
    respond_to do |format|
      @comment.update(comment_params)
      format.html { redirect_to topic_path(@topic), notice: 'コメントを更新しました。' }
      format.js { render :index }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:topic_id, :content, :id)
    end
end
