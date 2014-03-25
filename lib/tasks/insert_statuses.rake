namespace :db do
  desc 'Insert statuses in DB'
  task :insert_statuses =>  :environment do
    statuses = ['Online', 'Offline', 'Away', 'Do not disturb']
    statuses.each { |item|
      UserStat.create(:status_name => item)
      puts "Inserting status: #{item}"
    }
  end
end
