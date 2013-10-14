class FBMsgWorker
  include Sidekiq::Worker

  def perform(user_id, message)

    current_user=User.find(user_id)
    puts "Received on #{user_id}: #{message}"

		User.all.each do |user|
			unless user.id == current_user.id
				puts "start facebook send!!!!!!!!!!"
				puts "from#{current_user.uid}"
				puts "to#{user.uid}"

				id = "-#{current_user.uid}@chat.facebook.com"
				to = "-#{user.uid}@chat.facebook.com"
				body = message
				message = Jabber::Message.new to, body

				client = Jabber::Client.new Jabber::JID.new(id)
				client.connect
				client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, '215886731905255', current_user.oauth_token, '96c1ecb73693ad1ce0f6d0c754450c75'), nil)

				client.send message
				client.close
			end
		end
	end

end
