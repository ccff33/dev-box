name "mailcatcher"

default_attributes(
  "mailcatcher" => {
    "smtp-ip" => "127.0.0.1",
	"http-ip" => "127.0.0.1",
  }
)

run_list(
  "recipe[chef-mailcatcher]",
)
