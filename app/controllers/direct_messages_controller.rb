class DirectMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
    @chat_partner = User.find(params[:chat_partner_id])
    @private_message = PrivateMessage.new
    @private_messages = PrivateMessage.where(sender: current_user, receiver: @chat_partner)
                                      .or(PrivateMessage.where(sender: @chat_partner, receiver: current_user))
                                      .order(:created_at)
  end

  def create
    @chat_partner = User.find(params[:chat_partner_id])
    @private_message = PrivateMessage.new(private_message_params)
    @private_message.sender = current_user
    @private_message.receiver = @chat_partner
    @private_message.user_id = current_user.id

    if @private_message.save
      redirect_to direct_message_path(chat_partner_id: @chat_partner.id)
    else
      @private_messages = PrivateMessage.where(sender: current_user, receiver: @chat_partner)
                                        .or(PrivateMessage.where(sender: @chat_partner, receiver: current_user))
                                        .order(:created_at)
      render :show
    end
  end

  private

  def private_message_params
    params.require(:private_message).permit(:content)
  end
end
