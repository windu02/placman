set :application, ENV['APP_NAME']
set :repository,  ENV['APP_GIT_REPO']

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, ENV['DEPLOY_SERVER_FOLDER']
set :scm, :git
set :branch, "master"
set :user, ENV['DEPLOY_SERVER_USER']
set :use_sudo, false
set :rails_env, ENV['DEPLOY_RAILS_ENV']
set :deploy_via, :copy
# set :ssh_options, { :forward_agent => true, :port => 4321 }
set :keep_releases, 5
default_run_options[:pty] = true
server ENV['DEPLOY_WEB_URL'], :app, :web, :db, :primary => true

# role :web, ENV['DEPLOY_WEB_URL']                          # Your HTTP server, Apache/etc
# role :app, ENV['DEPLOY_SERVER_FOLDER']                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  desc "Symlink shared config files"
  task :symlink_config_files do
      run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
      run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/application.yml #{ current_path }/config/application.yml"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"