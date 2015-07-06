require 'yaml'
config = YAML.load_file('./database.yml')
config = config[Sinatra::Base.environment.to_s]

configure do
  set :db_host, config['host']
  set :db_port, config['port']
  set :db_password, config['password']
end