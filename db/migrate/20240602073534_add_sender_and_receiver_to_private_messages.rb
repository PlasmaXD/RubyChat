class AddSenderAndReceiverToPrivateMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :private_messages, :sender_id, :integer
    add_column :private_messages, :receiver_id, :integer
  end
end
