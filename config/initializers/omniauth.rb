Rails.application.config.middleware.use OmniAuth::Builder do

  provider :github, '2e13d0b4eca28a46a9b6', '890ea245e9987f2f019bf832ad21683f5e379223'
  provider :facebook, '711551912208839', '4cfa2872841fd786a1a55be4908a77ed'

end