Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '2faf16e2247cbfa6ea5d','b21104841d75d6a67160062fca67b4c6318a63b3'
  provider :facebook, '711551912208839', '4cfa2872841fd786a1a55be4908a77ed'
end