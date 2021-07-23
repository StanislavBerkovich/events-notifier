require './core/events/base_consumer'

module EventsConsumers
  class SyncBotSender < Core::Events::BaseConsumer
    def initialize(storage:, bot_client:)
      @storage = storage
      @bot_client = bot_client
    end

    def consume(event)
      channel_ids = @storage.channels_subscribed_for(event)
      channel_ids.each do |ch_id|
        @bot_client.send_message(ch_id, "You subscribed: #{event.to_json}")
      end
    end
  end
end
