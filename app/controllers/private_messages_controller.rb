class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @private_message = @chat_room.private_messages.build(private_message_params)
    @private_message.sender = current_user
    @private_message.receiver = @chat_room.users.where.not(id: current_user.id).first
    @private_message.user_id = current_user.id

    if @private_message.save
      redirect_to @chat_room
    else
      render 'chat_rooms/show'
    end
  end

  private

  def private_message_params
    params.require(:private_message).permit(:content)
  end
end
