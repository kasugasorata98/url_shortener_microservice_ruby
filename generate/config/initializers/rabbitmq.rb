require 'yaml'

require 'bunny'

rabbitmq_config = YAML.load_file("#{Rails.root}/config/rabbitmq.yml")[Rails.env]

$rabbitmq_connection = Bunny.new(
  host: rabbitmq_config['host'],

  port: rabbitmq_config['port'],

  username: rabbitmq_config['username'],

  password: rabbitmq_config['password'],

  vhost: rabbitmq_config['vhost'],

  tls: rabbitmq_config['tls'],

  ssl_verify_peer: rabbitmq_config['ssl_verify_peer']
)

$rabbitmq_connection.start

at_exit do
  $rabbitmq_connection.close
end

$channel = $rabbitmq_connection.create_channel

# Define the URL_SHORTENER exchange

$url_shortener_exchange = $channel.exchange('URL_SHORTENER', durable: true)
