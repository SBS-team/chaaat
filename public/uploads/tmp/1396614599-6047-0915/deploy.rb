## config valid only for Capistrano 3.1
#lock '3.1.0'
#
#set :application, 'my_app_name'
#set :repo_url, 'git@example.com:me/my_repo.git'
#
#set :stages, ["preproduction", "production"]
#
## Default branch is :master
## ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
#
## Default deploy_to directory is /var/www/my_app
## set :deploy_to, '/var/www/my_app'
#
## Default value for :scm is :git
## set :scm, :git
#
## Default value for :format is :pretty
## set :format, :pretty
#
## Default value for :log_level is :debug
## set :log_level, :debug
#
## Default value for :pty is false
## set :pty, true
#
## Default value for :linked_files is []
## set :linked_files, %w{config/database.yml}
#
## Default value for linked_dirs is []
## set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
#
## Default value for default_env is {}
## set :default_env, { path: "/opt/ruby/bin:$PATH" }
#
## Default value for keep_releases is 5
## set :keep_releases, 5
#
#namespace :deploy do
#
#  desc 'Restart application'
#  task :restart do
#    on roles(:app), in: :sequence, wait: 5 do
#      # Your restart mechanism here, for example:
#      # execute :touch, release_path.join('tmp/restart.txt')
#    end
#  end
#
#  after :publishing, :restart
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end
#
#end

require 'rvm/capistrano' # for rvm
require 'bundler/capistrano' # for bundler. While changing bundler automatically update all the gems on the serer to match all developers gems.
require 'capistrano/ext/multistage'

set :using_rvm, true

set :application, 'ruby-chat'
set :use_sudo, false
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = ['publickey']

set :scm, :git # Using git.
set :repository,  'github.com/SBS-team/chaaat.git' # Path to your repository
set :deploy_via, :remote_cache # Using cache. Deploying only changes.

set :stages,          %w(preproduction production)
set :default_stage,   'preproduction'
set :keep_releases, 3

set :migrate_target, :latest

set :rvm_ruby_string, "ruby-2.1.0-p0@ruby-chat_#{stage}"

after 'deploy:finalize_update', 'deploy:migrate'
before 'deploy:migrate', 'config:symlink'

before 'deploy:setup', 'rvm:install_ruby'
after 'deploy:setup', 'config:setup_folders'

namespace :config do
  desc 'Symlink configuration files.'
  task :symlink do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/production.yml #{release_path}/config/production.yml"
  end

  task :setup_folders do
    run "touch -m #{shared_path}/database.yml"
    run "touch -m #{shared_path}/production.yml"
  end
end

namespace :rails do
  desc 'Open the rails console on one of the remote servers'
  task :console, roles: :app do
    exec "ssh -l #{user} '192.168.137.75' -t 'cd #{current_path} && bundle install && bundle exec rails c #{stage}'"
  end
end

desc 'tail production log files'
task :tail_logs, roles: :app do
  trap('INT') { puts 'Interupted'; exit 0; }
  run "tail -f #{shared_path}/log/#{stage}.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

after 'deploy', 'deploy:cleanup'