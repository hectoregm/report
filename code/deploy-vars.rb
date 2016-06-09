set :config_defaults, {
  appdirname: "peat",
  c3server: "http://c3server.com:8080",
  nginx_port: 8888,
  rails_env: "production",
  tenant: "peat",
  tag: "prod",
  # ...
}

set :stages, %w{peatstage peattest peatqa peatprod}
set :application, "peat"

set :scm, :git
set :repository,  "git@server.com:c3energy/peat.git"
set :branch, "#{ENV['branch'] || 'release/v1.0'}"

# Tareas para inicializar el ambiente
after "deploy:setup", "deploy:peat_setup"
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

# Se reinicia el sistema después de actualizar su configuración
after "peat:config_sync", "deploy:restart"