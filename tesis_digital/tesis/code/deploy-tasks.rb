namespace :deploy do
  desc "Crear archivos de configuración para upstart"
  task :upstart do
    run "cd #{current_path} && rvmsudo bundle exec foreman export upstart /etc/init -a #{application} -u nginx -t ./foreman"
  end
  desc "Iniciar sistema PEAT"
  task :start do
    sudo "/sbin/start #{application}"
  end
  desc "Parar sistema PEAT"
  task :stop do
    sudo "/sbin/stop #{application}"
  end
  desc "Transferir archivos de configuración para PEAT y Nginx"
  task :peat_setup do
    transfer_config_files(server_env)
    run "cp #{shared_path}/nginx.conf /opt/nginx/conf/nginx.conf"
  end
end

namespace :peat do
  desc "Transferir archivos de configuración para PEAT y Nginx y el sistema se reinicia."
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
    config_defaults[:rails_env] = "test"
    config_defaults[:c3server] = "https://peatstage-admin.c3server.com"
    config_defaults[:tag] = "cucumber"
    ConfigCreator.new(config_defaults).write
  end
end