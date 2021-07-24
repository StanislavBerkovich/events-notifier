module Core
  class BotProcessor
    SUBSCRIBE_START_WITH = 'AddSub'.freeze

    def initialize(client:, subscriptions_storage:)
      @client = client
      @subscriptions_storage = subscriptions_storage
    end

    def start
      @client.handle_subscribe do |subscription, channel_id|
        unless subscription.is_a?(Hash)
          client.raise_invalid_subscription_error("Subscription must be single object")
        end

        @subscriptions_storage.add_subscription(subscription, channel_id)
        @subscriptions_storage.subscriptions(channel_id)
      end

      @client.handle_unsubscribe_all do |channel_id|
        @subscriptions_storage.unsubscribe_all(channel_id)
        @subscriptions_storage.subscriptions(channel_id)
      end

      @client.handle_unsubscribe do |subscription_id, channel_id|
        @subscriptions_storage.unsubscribe(subscription_id, channel_id)
        @subscriptions_storage.subscriptions(channel_id)
      end

      @client.handle_subscriptions do |channel_id|
        @subscriptions_storage.subscriptions(channel_id)
      end

      @client.start
    end
  end
end
