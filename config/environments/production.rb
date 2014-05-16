Chat::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  # config.action_dispatch.rack_cache = true
  config.serve_static_assets = true
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass
  config.assets.compile = true
  config.assets.digest = true
  config.assets.version = '1.0'
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
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
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.log_formatter = ::Logger::Formatter.new
  CarrierWave.configure do |config|
    config.dropbox_app_key = ENV["DROPBOX_APP_KEY"]
    config.dropbox_app_secret = ENV["DROPBOX_APP_SECRET"]
    config.dropbox_access_token = ENV["DROPBOX_ACCESS_TOKEN"]
    config.dropbox_access_token_secret = ENV["DROPBOX_ACCESS_TOKEN_SECRET"]
    config.dropbox_user_id = ENV["DROPBOX_USER_ID"]
    config.dropbox_access_type = "app_folder"
  end

end
