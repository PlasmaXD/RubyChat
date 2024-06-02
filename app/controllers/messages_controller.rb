class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params.merge(user: current_user))

    if @message.save
      ActionCable.server.broadcast "chat_room_#{@chat_room.id}_channel", { message: render_message(@message) }
      head :ok
    else
      render 'chat_rooms/show'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end