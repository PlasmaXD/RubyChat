class PrivateMessage < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :chat_room, optional: true

  validates :content, presence: true

  def user
    sender
  end
end
