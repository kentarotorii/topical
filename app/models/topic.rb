class Topic < ActiveRecord::Base
  validates :content, length: {in: 1..140}
  belongs_to :user
  has_many :comments, dependent: :destroy
  mount_uploader :image, ImageUploader
end
