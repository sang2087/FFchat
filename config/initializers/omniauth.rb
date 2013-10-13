OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '215886731905255', '96c1ecb73693ad1ce0f6d0c754450c75', {:scope=>"xmpp_login, ads_management"}
end
