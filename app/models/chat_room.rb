class ChatRoom < ApplicationRecord
  has_many :chat_room_users, dependent: :destroy
  has_many :private_messages, dependent: :destroy
  has_many :users, through: :chat_room_users
  validates :name, presence: true # 一意性のバリデーションを削除

  # validates :name, presence: true, uniqueness: true
end
