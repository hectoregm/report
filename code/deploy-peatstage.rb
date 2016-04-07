set :hostname, 'dev-peatstage-ruby-01.c3-e.com'
server "#{hostname}", :app, :web, :db, :primary => true

set :branch, "#{ENV['branch'] || 'master'}"
set :application, "pge"
set :deploy_to, "/home/nginx/rails_app/peat-pge"

set :appdirname, "peat-pge"
set :c3server, "http://peatstage.c3server.com:8080"
set :rails_env, "staging"

def override_defaults
  config_defaults[:appdirname] = appdirname
  config_defaults[:server_name] = server_name
  config_defaults[:c3server] = c3server
  config_defaults[:railsenv] = rails_env
end

def write_and_transfer_config_files
  override_defaults
  ConfigCreator.new(config_defaults).write
  puts "Transfering config/peat.yml"
  transfer(:up, "tmp/peat.yml", "#{shared_path}/peat.yml")
  puts "Transfering nginx conf file"
  transfer(:up, "tmp/nginx.conf", "#{shared_path}/nginx.conf")
  run "cp #{shared_path}/nginx.conf /opt/nginx/conf/nginx.conf.#{application}"
end

namespace :deploy do
  task :peat_setup do
    write_and_transfer_config_files
  end
end

namespace :peat do
  task :config_sync do
    write_and_transfer_config_files
  end
end

namespace :generate do
  task :config do
    override_defaults
    ConfigCreator.new(config_defaults).write
  end
end
