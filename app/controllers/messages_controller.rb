class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages.order(:created_at)

    @messages.each do |m|
      if m.recipient_id == current_user.id
        m.update(read: true)
      end
    end

    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

#    if @messages.last
#      if @messages.last.user_id != current_user.id
#        @messages.last.update(read: true)
#      end
#    end


    @message = @conversation.messages.build

  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save

      unless @message.recipient_id == current_user.id
        Pusher.trigger("user_#{@message.recipient_id}_channel", 'new_message', {
        message: 'あなた宛てにメッセージが届きました'
        })
      end
      Pusher.trigger("user_#{@message.recipient_id}_channel", 'message_arrival_created', {
        arrival_counts: Message.where(recipient_id: @message.recipient_id, read: false).count
      })

      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to conversation_messages_path(@conversation), :notice => @message.errors.full_messages.first
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id, :recipient_id)
  end
end
