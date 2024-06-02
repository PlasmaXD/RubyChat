# Rails.application.routes.draw do
#   devise_for :users
#   resources :users, only: [:index] # ユーザー一覧のルートを追加
#   resources :chat_rooms, only: [:index, :show, :new, :create] do
#     resources :private_messages, only: [:create]
#   end
#
#   # Direct message routes
#   get 'direct_message', to: 'direct_messages#show', as: 'direct_message'
#   post 'direct_message', to: 'direct_messages#create'
#
#   root "chat_rooms#index"
# end
Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index] # ユーザー一覧のルートを追加

  resources :chat_rooms, only: [:index, :show, :new, :create, :destroy] do
    resources :private_messages, only: [:create]
  end

  # Direct message routes
  get 'direct_messages', to: 'direct_messages#index', as: 'direct_messages'
  get 'direct_message', to: 'direct_messages#show', as: 'direct_message'
  post 'direct_message', to: 'direct_messages#create'

  root "chat_rooms#index"
end
