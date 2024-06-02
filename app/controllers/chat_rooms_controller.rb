class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:show, :destroy]

  def index
    @chat_rooms = current_user.chat_rooms
  end

  def show
    @private_message = PrivateMessage.new
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    user_ids = params[:chat_room][:user_ids].reject(&:blank?) # 選択されたユーザーIDを取得し、空のIDを除去

    if user_ids.size == 1
      # 一対一のチャットの場合、チャットルームを作成せずに個別チャットを開始
      chat_partner = User.find(user_ids.first)
      # ここに一対一のチャット処理を追加（例: メッセージページにリダイレクト）
      redirect_to direct_message_path(chat_partner_id: chat_partner.id)
    else
      # 複数ユーザーの場合、チャットルームを作成
      @chat_room = ChatRoom.new(chat_room_params)
      if @chat_room.save
        @chat_room.chat_room_users.create!(user: current_user)
        user_ids.each do |user_id|
          @chat_room.chat_room_users.create!(user_id: user_id) rescue nil
        end
        redirect_to @chat_room
      else
        render :new
      end
    end
  end

  def destroy
    @chat_room.destroy
    redirect_to chat_rooms_path, notice: 'Chat room was successfully deleted.'
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name, user_ids: [])
  end
end
