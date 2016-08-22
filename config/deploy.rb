# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'siloette'
set :repo_url, 'git@example.com:me/my_repo.git'

set :application, 'siloette'
set :repo_url, 'git@github.com:ranaldschulz/siloette2.git'
set :deploy_to, '/var/www/siloette'
set :scm, :git
set :format, :airbrussh
set :log_level, :debug

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/images')
set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/database.yml', 'config/secrets.yml')

set :rvm_type, :user
set :rvm_ruby_version, '2.3.1'

# Default value for keep_releases is 5
set :keep_releases, 3

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end