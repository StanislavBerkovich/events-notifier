module EventsConsumers
  class SyncBotSender
    def initialize(subscriptions_service:, bot_client:)
      @subscriptions_service = subscriptions_service
      @bot_client = bot_client
    end

    def consume(event)
      channel_ids = @subscriptions_service.channels_subscribed_for(event)
      channel_ids.each do |ch_id|
        @bot_client.send_message(ch_id, "You subscribed: #{event.to_json}")
      end
    end
  end
end
