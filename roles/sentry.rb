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
  "recipe[apt]",
  "recipe[mysql::client]",
  "recipe[database::mysql]",
  "recipe[mysql::server]",
  "recipe[python]",
  "recipe[git]",
  "recipe[vim]",
  "recipe[supervisor]",
  "recipe[sentry]",
)
