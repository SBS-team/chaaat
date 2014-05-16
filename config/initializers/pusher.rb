#require 'pusher'
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

#Pusher.url = "http://255267aae6802ec7914f:456aa3a324e2b5e8a2f2@api.pusherapp.com/apps/68323"
Pusher.logger = Rails.logger

Pusher.host   = ENV['PUSHER_HOST']
Pusher.port   = ENV['PUSHER_PORT']
