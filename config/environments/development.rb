Chat::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true

config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: ENV["DOMAIN_NAME"],
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: ENV["GMAIL_USERNAME"],
      password: ENV["GMAIL_PASSWORD"]
  }

  config.action_mailer.default_url_options = {:host => "ruby-chat-st.loc"}
  config.action_mailer.perform_deliveries = true


CarrierWave.configure do |config|
  config.dropbox_app_key = ENV["DROPBOX_APP_KEY"]
  config.dropbox_app_secret = ENV["DROPBOX_APP_SECRET"]
  config.dropbox_access_token = ENV["DROPBOX_ACCESS_TOKEN"]
  config.dropbox_access_token_secret = ENV["DROPBOX_ACCESS_TOKEN_SECRET"]
  config.dropbox_user_id = ENV["DROPBOX_USER_ID"]
  config.dropbox_access_type = "app_folder"
end

end