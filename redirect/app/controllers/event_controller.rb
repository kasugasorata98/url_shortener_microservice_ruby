class EventController < ApplicationController
  def handle_message(message)
    event, payload = message.values_at('event', 'payload')

    case event

    when 'ADD_TO_REDIRECT'

      add_to_redirect_mapping(payload)

    else

      # do something when event is none of the above

      put 'event not recognized'

    end
  end

  private

  def add_to_redirect_mapping(payload)
    redirect_mapping = RedirectMapping.new(
      url_mapping_id: payload['id'],

      target_url: payload['target_url'],

      short_id: payload['short_id']
    )

    if redirect_mapping.save

      puts 'Redirect mapping created successfully'

    else

      puts 'Error creating redirect mapping'

    end
  end
end
