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

$url_shortener_queue = $channel.queue('REDIRECT_SERVICE', durable: true)

$url_shortener_queue.bind($url_shortener_exchange, routing_key: 'REDIRECT_SERVICE')

# Define the consumer for the UrlMappingCreated queue

$url_shortener_consumer = Bunny::Consumer.new($channel, $url_shortener_queue)

# Define the callback function to handle incoming messages

def handle_url_mapping_created_event(message)
  redirect_mapping = RedirectMapping.new(
    url_mapping_id: message['id'],

    target_url: message['target_url'],

    short_id: message['short_id']
  )

  redirect_mapping.save!
end

# Start consuming messages from the UrlMappingCreated queue

$url_shortener_queue.subscribe_with($url_shortener_consumer, block: false)

Rails.application.config.after_initialize do
  $url_shortener_consumer.on_delivery do |delivery_info, _properties, payload|
    message = JSON.parse(payload)

    EventController.new.handle_message(message)

    $channel.ack(delivery_info.delivery_tag)
  end
end
