include_recipe "python"
include_recipe "database::mysql"

sentry_user = "www-sentry"
sentry_group = "www-sentry"
sentry_home = "/www/sentry"
sentry_config_file = "/etc/sentry.conf.py"
sentry_command = sentry_home + "/bin/sentry"

group sentry_group

user sentry_user do
  group sentry_group
  home sentry_home
  action [:create, :manage]
end

directory sentry_home do
  owner sentry_user
  group sentry_group
  mode "0777"
  recursive true
  action :create
end

file sentry_config_file do
  content ""
  owner sentry_user
  group sentry_group
  mode "0777"
  action :create
end

python_virtualenv sentry_home do
  owner sentry_user
  group sentry_group
  action :create
end

python_pip "sentry[mysql]" do
  virtualenv sentry_home
end

mysql_database "sentry" do
  connection(
    :host     => "localhost",
    :username => "root",
    :password => node['mysql']['server_root_password']
  )
  action :create
end

execute "init" do
  command "echo 'Y' | " + sentry_command + " init " + sentry_config_file
end

ruby_block "sentry config" do
  block do
    fe = Chef::Util::FileEdit.new(sentry_config_file)
	fe.search_file_replace(/django\.db\.backends\.sqlite3/, 'django.db.backends.mysql')
	fe.search_file_replace(/'NAME': os\.path\.join\(CONF_ROOT, 'sentry\.db'\)/, '\'NAME\': \'sentry\'')
	fe.search_file_replace(/'USER': 'postgres'/, '\'USER\': \'root\'')
	fe.search_file_replace(/'PASSWORD': ''/, '\'PASSWORD\': \'' + node['mysql']['server_root_password'] + '\'')
	fe.search_file_replace(/SENTRY_URL_PREFIX = 'http:\/\/sentry.example.com'/, 'SENTRY_URL_PREFIX = \'http://localhost:9000\'')
    fe.write_file
  end
end

execute "migrations" do
  command sentry_command + " --config=" + sentry_config_file + " upgrade --noinput"
end

supervisor_service "sentry-web" do
  action :enable
  autostart true
  autorestart true
  redirect_stderr true
  user sentry_user
  directory sentry_home
  command sentry_command + " --config=" + sentry_config_file + " start http"
end