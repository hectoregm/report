set :config_defaults, {
  appdirname: "peat",
  c3server: "http://c3server.com:8080",
  nginx_port: 8888,
  railsenv: "staging",
  tenant: "peat",
  tag: "prod",
  # ...
}

set :stages, %w{peatstage peattest peatqa peatprod}
set :application, "peat"
set :server_env, "peat"
set :rails_env,  "staging"

set :scm, :git
set :repository,  "git@github.com:c3-e/peat.git"
set :branch, "#{ENV['branch'] || 'master'}"

# Inicializacion del ambiente
after "deploy:setup", "deploy:peat_setup"
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

# ...

# Se reinicia el sistema despues de actualizar su configuración.
after "peat:config_sync", "deploy:restart"

namespace :deploy do
  desc "Create upstart config files"
  task :upstart do
    run "cd #{current_path} && rvmsudo bundle exec foreman export upstart /etc/init -a #{application} -u nginx -t ./foreman"
  end
  desc "Start peat application"
  task :start do
    sudo "/sbin/start #{application}"
  end
  desc "Stop peat application"
  task :stop do
    sudo "/sbin/stop #{application}"
  end
  desc "Peat adhoc setup"
  task :peat_setup do
    transfer_config_files(server_env)
    run "cp #{shared_path}/nginx.conf /opt/nginx/conf/nginx.conf"
  end
end

namespace :peat do
  desc "Upload up to date peat.yml and nginx.conf, then it restarts the application."
  task :config_sync do
    transfer_config_files(server_env)
    run "cp #{shared_path}/nginx.conf /opt/nginx/conf/nginx.conf"
  end
end

namespace :generate do
  task :config do
    ConfigCreator.new(config_defaults).write
  end
  task :jenkins do
    config_defaults[:railsenv] = "test"
    config_defaults[:c3server] = "https://peatstage-admin.c3-e.com"
    config_defaults[:tag] = "cucumber"
    ConfigCreator.new(config_defaults).write
  end
end