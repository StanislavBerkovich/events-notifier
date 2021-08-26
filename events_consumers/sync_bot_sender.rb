module EventsConsumers
  class SyncBotSender
    def initialize(subscriptions_service:, events_service:, bot_client:, wait_time: 5)
      @subscriptions_service = subscriptions_service
      @events_service = events_service
      @bot_client = bot_client
      @wait_time = wait_time
    end

    def consume
      while true
        was_events = false
        @events_service.process_events_batch do |events|
          was_events ||= events.size != 0

          events.each do |event|
            channel_ids = @subscriptions_service.channels_subscribed_for(event)
            message = event['text'].nil? ? "Event: #{event.to_json}" : event['text'].to_s

            mentions = event['subjects']&.select { |s| s.include?('@') } || []
            channel_ids.each do |ch_id|
              @bot_client.send_message(ch_id, message, emails_mention: mentions)
            end
          end

          true
        end
        unless was_events
          puts 'No events. Consumer sleeps'
          sleep(@wait_time)
        end
      end
    end
  end
end
