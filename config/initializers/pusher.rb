require 'pusher'
if ENV['PUSHER_APP']
  Pusher.url = "http://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api-eu.pusher.com/apps/#{ENV['PUSHER_APP']}"
end

if ENV['SLANGER_APP']
  Pusher.app_id = ENV['SLANGER_APP']
  Pusher.key = ENV['SLANGER_KEY']
  Pusher.secret = ENV['SLANGER_SECRET']
  Pusher.host = ENV['SLANGER_HOST']
  Pusher.port = ENV['SLANGER_PORT']
end
