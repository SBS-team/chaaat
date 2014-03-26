# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.
#User.delete_all
#Room.delete_all
#RoomsUser.delete_all
#
#for i in 1..5 do
#  User.create(:email => "user#{i}@mail.com", :password => "userpass#{i}",
#              :password_confirmation => "userpass#{i}",
#              :firstname => "user#{i}", :lastname => "user#{i}")
#end
#namespace :rake do
#  namespace :db do
#    desc 'Insert statuses in DB'
#    task :insert_statuses =>  :environment do
#      statuses = ['Online', 'Offline', 'Away', 'Do not disturb']
#      statuses.each { |item|
#        UserStat.create(:status_name => item)
#        puts "Inserting status: #{item}"
#      }
#    end
#  end
#end