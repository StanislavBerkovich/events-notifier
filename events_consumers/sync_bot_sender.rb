module EventsConsumers
  class SyncBotSender
    def initialize(subscriptions_storage:, bot_client:)
      @subscriptions_storage = subscriptions_storage
      @bot_client = bot_client
    end

    def consume(event)
      channel_ids = @subscriptions_storage.channels_subscribed_for(event)
      channel_ids.each do |ch_id|
        @bot_client.send_message(ch_id, "You subscribed: #{event.to_json}")
      end
    end
  end
end
