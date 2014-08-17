name "sentry"

default_attributes(
  "mysql" => {
    "server_root_password" => 'rrrrr',
    "server_repl_password" => 'rrrrr',
    "server_debian_password" => 'rrrrr',
  },
)

run_list(
  "recipe[build-essential]",
  "recipe[database::mysql]",
  "recipe[apt]",
  "recipe[mysql::server]",
  "recipe[mysql::client]",
  "recipe[python]",
  "recipe[git]",
  "recipe[vim]",
  "recipe[supervisor]",
  "recipe[sentry]",
)
