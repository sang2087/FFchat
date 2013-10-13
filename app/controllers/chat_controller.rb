class ChatController < ApplicationController

	before_filter :login_check
  def index
    @chat_messages = ChatMessage.find
		@user=User.find(session[:user_id])
  end
end
