set :hostname, 'dev-peatstage-ruby-01.c3-e.com'
server "#{hostname}", :app, :web, :db, :primary => true

set :branch, "#{ENV['branch'] || 'master'}"
set :rails_env, "staging"
set :application, "pge"
set :deploy_to, "/home/#{user}/rails_app/peat-pge"

# Config overrides
set :appdirname, "peat-pge"
set :c3server, "http://peatstage.c3server.com:8080"

before "deploy:restart", "deploy:upstart"

def override_defaults
  config_defaults[:appdirname] = appdirname
  config_defaults[:server_name] = server_name
  config_defaults[:c3server] = c3server
end

namespace :deploy do
  desc "Peat adhoc setup"
  task :peat_setup do
    override_defaults
    ConfigCreator.new(config_defaults).write
    puts "Transfering config/peat.yml"
    transfer(:up, "tmp/peat.yml", "#{shared_path}/peat.yml")
    puts "Transfering nginx conf file"
    transfer(:up, "tmp/nginx.conf", "#{shared_path}/nginx.conf")
    run "mkdir -p #{shared_path}/pdf_downloads"
  end
end

namespace :peat do
  desc "Upload upto date peat.yml and nginx.conf, then it restarts the application."
  task :config_sync do
    override_defaults
    ConfigCreator.new(config_defaults).write
    puts "Transfering config/peat.yml"
    transfer(:up, "tmp/peat.yml", "#{shared_path}/peat.yml")
    puts "Transfering nginx conf file"
    transfer(:up, "tmp/nginx.conf", "#{shared_path}/nginx.conf")
    run "cp #{shared_path}/nginx.conf /opt/nginx/conf/nginx.conf.#{application}"
  end
end

namespace :generate do
  task :config do
    override_defaults
    ConfigCreator.new(config_defaults).write
  end
end
