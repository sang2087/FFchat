FFchat::Application.routes.draw do
  faye_server '/faye', timeout: 25 do
    map '/chat' => RealtimeChatController
    map default: :block
  end

  resources :chat
	root to:'chat#index'

  match ':controller(/:action(/:id))(.:format)'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
	
	
end
