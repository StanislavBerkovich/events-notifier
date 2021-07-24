module Core
  class SubscriptionsFacade
    BaseError = Class.new(StandardError)
    InvalidSubscriptionError = Class.new(BaseError)

    def initialize(storage:)
      @storage = storage
    end

    def subscribe(subscription, channel_id)
      unless subscription.is_a?(Hash)
        raise InvalidSubscription, "Subscription must be single object"
      end

      @storage.add_subscription(subscription, channel_id)
    end

    def unsubscribe_all(channel_id)
      @storage.unsubscribe_all(channel_id)
    end

    def unsubscribe(subscription_id, channel_id)
      @storage.unsubscribe(subscription_id, channel_id)
    end

    def list(channel_id)
      @storage.subscriptions(channel_id)
    end

    def channels_subscribed_for(event)
      @storage.channels_subscribed_for(event)
    end
  end
end
