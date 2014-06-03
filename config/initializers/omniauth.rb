Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '5690879f7c91a6521a88', '9395adef4ad5487be40541b5fffa32a183ab30f3', :scope => 'user:email'
  provider :facebook, '297828783725765', '428ab150c0359303095b000331da9e86'
  provider :google_oauth2, "530975273735-9rd275aq2cirucpvdr8g1o8jom0mipsr.apps.googleusercontent.com", "7xtBDRtfJFQ8bn50zAE75fq3"
  provider :twitter, 'KhdYntmzO9QfPiwmrYMtv1Iuh', '1DBXx2L1BdBWnIAsq3CQQzmm5tYJsQ5rOorAubC8d00yhpUZR1'
end
