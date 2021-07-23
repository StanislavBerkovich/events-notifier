module Apps
  class BotProcessor
    SUBSCRIBE_START_WITH = 'AddSub'.freeze

    def initialize(client:, storage:)
      @client = client
      @storage = storage
    end

    def start
      @client.handle_subscribe do |subscription, channel_id|
        unless subscription.is_a?(Hash)
          client.raise_invalid_subscription_error("Subscription must be single object")
        end

        @storage.add_subscription(subscription, channel_id)
        @storage.subscriptions(channel_id)
      end

      @client.handle_unsubscribe_all do |channel_id|
        @storage.unsubscribe_all(channel_id)
        @storage.subscriptions(channel_id)
      end

      @client.handle_unsubscribe do |subscription_id, channel_id|
        @storage.unsubscribe(subscription_id, channel_id)
        @storage.subscriptions(channel_id)
      end

      @client.handle_subscriptions do |channel_id|
        @storage.subscriptions(channel_id)
      end

      @client.start
    end
  end
end
