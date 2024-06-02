class User < ApplicationRecord
  # Deviseのモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # チャットルームとの関連付け
  has_many :chat_room_users
  has_many :chat_rooms, through: :chat_room_users
end

