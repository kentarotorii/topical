class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, scope: :recipient_id
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end

  def unread_message(current_user)
    return Message.where(conversation_id: id, recipient_id: current_user.id, read: false)
  end

  def has_unread_message(current_user)
    return Message.where(conversation_id: id, recipient_id: current_user.id, read: false).count
  end

  def latest_unread_message(current_user)
    return Message.where(conversation_id: id, recipient_id: current_user.id, read: false).last
  end
end
