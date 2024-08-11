class ChangeChatRoomIdInPrivateMessages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :private_messages, :chat_room_id, true
  end
end
