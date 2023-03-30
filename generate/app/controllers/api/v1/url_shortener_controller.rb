class Api::V1::UrlShortenerController < ApplicationController
  def create
    target_url = params[:targetUrl]
    short_id = generate_short_id

    # Save the short URL to your database
    url_mapping = UrlMapping.create(target_url:, short_id:)
    publish_message(url_mapping)
    render json: { shortId: url_mapping.short_id }, status: :created
  end

  private

  def publish_message(url_mapping)
    message = {
      event: 'ADD_TO_REDIRECT',
      payload: {
        id: url_mapping.id,
        target_url: url_mapping.target_url,
        short_id: url_mapping.short_id
      }
    }
    $url_shortener_exchange.publish(message.to_json, routing_key: 'REDIRECT_SERVICE')
  end

  def generate_short_id
    # Set the initial short ID length to 5 characters
    length = 5

    # Generate a new short ID and check if it's unique
    loop do
      # Generate a random string of the current length
      short_id = SecureRandom.urlsafe_base64(length)[0, length]

      # Check if the short ID already exists in the database
      return short_id unless UrlMapping.exists?(short_id:)

      # If the short ID already exists, increase the length by 1 (up to a maximum of 15)
      length += 1
      length = 15 if length > 15

      # If the short ID is unique, return it
    end
  end
end
