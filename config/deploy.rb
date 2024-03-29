# config valid only for current version of Capistrano

set :application, 'panopticon'
set :repo_url, 'git@github.com:astralbrands/panopticon.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/panopticon'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{release_path}" do
        execute "bin/panopticon", "daemonize"
      end
    end
  end

  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{release_path}" do
        execute "bin/panopticon", "stop", raise_on_non_zero_exit: false
      end
    end
  end

  after 'deploy:started', 'deploy:stop'
  after 'deploy:publishing', 'deploy:restart'

end
