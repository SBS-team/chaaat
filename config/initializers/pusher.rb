#require 'pusher'
#FIXME move to ENV
Pusher.app_id = '68323'
Pusher.key = '255267aae6802ec7914f'
Pusher.secret = '456aa3a324e2b5e8a2f2'

#Pusher.url = "http://255267aae6802ec7914f:456aa3a324e2b5e8a2f2@api.pusherapp.com/apps/68323"
Pusher.logger = Rails.logger

Pusher.host   = '192.168.137.75'
Pusher.port   = 4567
