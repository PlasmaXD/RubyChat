class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @private_message = @chat_room.private_messages.build(private_message_params)
    @private_message.user = current_user

    if @private_message.save
      ActionCable.server.broadcast "chat_room_#{@chat_room.id}_channel", { message: render_message(@private_message) }
      head :ok
    else
      render 'chat_rooms/show'
    end
  end

  private

  def private_message_params
    params.require(:private_message).permit(:content)
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'private_messages/private_message', locals: { private_message: message })
  end
end
# frozen_string_literal: true

