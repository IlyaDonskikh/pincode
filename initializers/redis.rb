Redis.current = Redis.new(
  host: settings.db_host,
  port: settings.db_port,
  password: settings.db_password)
