# config valid only for Capistrano 3.1
SSHKit.config.command_map[:rake] = "bundle exec rake"

lock '3.1.0'
set :application, 'chat'
set :use_sudo, false

set :repo_url, 'git@github.com:SBS-team/chaaat.git'
set :deploy_via, :remote_cache

set :stages,          %w(staging production)
set :default_stage,    'production'

set :rvm_type, :system
set :rvm_ruby_version, "ruby-2.1.0@chat"

set :deploy_to, "/home/deployer/staging/#{fetch(:application)}/#{fetch(:stage)}"
set :scm, :git

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"

set :keep_releases, 3

namespace :deploy do
  task :restart do
    on "deployer@192.168.137.75" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D; fi"
    end
  end
  task :start do
    on roles [:web, :app] do
      within "#{fetch(:deploy_to)}/current" do
        execute :bundle,:exec, "unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
      end
    end
  end
  task :stop do
    on "deployer@192.168.137.75" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end
end
after "deploy:restart", "deploy:cleanup"