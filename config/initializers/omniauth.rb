Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '2e13d0b4eca28a46a9b6', '995e51a4698089e0525d3e152d42f4404c7b16a6', :scope => 'user:email'
  provider :facebook, '646226855446942', 'c5c2fcd0ffdf1a0728f590c83ffa344b'
end