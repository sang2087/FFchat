class ChatMessage
  HISTORY = 20

  attr_accessor :name, :message, :created_at, :user_id

  def initialize(name, message, created_at=Time.now, user_id)
    @name = name
    @message = message
    @created_at = created_at
		@user_id = user_id

		puts "MESSAGE#{message} #{user_id}"
    self.class.push self
    #self.class.send_facebook_message @user_id,@message
    FBMsgWorker.perform_async @user_id, @message
  end

  def self.push(chat_message)
    @chat_messages ||= []
    @chat_messages << chat_message
    @chat_messages = @chat_messages.reverse.take(HISTORY).reverse
  end

  def self.find
    @chat_messages ||= []
  end
	
	def self.send_facebook_message  user_id, message
		User.all.each do |user|
			unless user.id == user_id.to_i
				puts "start facebook send!!!!!!!!!!"
				puts User.find(user_id).uid
				puts user.uid

				id = "-#{User.find(user_id).uid}@chat.facebook.com"
				to = "-#{user.uid}@chat.facebook.com"
				body = message
				message = Jabber::Message.new to, body

				client = Jabber::Client.new Jabber::JID.new(id)
				client.connect
				client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, '215886731905255', User.find(user_id).oauth_token, '96c1ecb73693ad1ce0f6d0c754450c75'), nil)

				client.send message
				client.close
			end
		end
	end
end
