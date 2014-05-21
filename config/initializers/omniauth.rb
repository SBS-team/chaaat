Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '2e13d0b4eca28a46a9b6', '995e51a4698089e0525d3e152d42f4404c7b16a6', :scope => 'user:email'
  provider :facebook, '646226855446942', 'c5c2fcd0ffdf1a0728f590c83ffa344b'
  provider :google_oauth2, '193320710377-5r39v1oulkmh8kj8s6hqs56qbc3aahgu.apps.googleusercontent.com', 'G_-WyY8u0SNIStKM4tUpZxlo'
  provider :twitter, '6NMRFWhAYafFt9u7BNTbprAEp', 'fN4gjeSTrp6NjOsrpklhelGpJsLhfB2xd2kc6XxtEWrN0T3mVb'
end
