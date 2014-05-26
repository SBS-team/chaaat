task :config_db do
  FileUtils.cp "config/database.#{ENV['DB'] || 'postgres'}.yml", 'config/database.yml'
end