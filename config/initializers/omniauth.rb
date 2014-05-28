Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '5690879f7c91a6521a88', '9395adef4ad5487be40541b5fffa32a183ab30f3', :scope => 'user:email'
  provider :facebook, '646226855446942', 'c5c2fcd0ffdf1a0728f590c83ffa344b'
end