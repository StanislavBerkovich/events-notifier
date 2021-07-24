module Core
  module Subscriptions
    class BaseStorage
      def add_subscription(subscription, channel_id)
        raise NotImplementedError
      end

      def subscriptions(channel_id)
        raise NotImplementedError
      end

      def unsubscribe_all(channel_id)
        raise NotImplementedError
      end

      def unsubscribe(subscription_id, channel_id)
        raise NotImplementedError
      end

      def channels_subscribed_for(event)
        raise NotImplementedError
      end
    end
  end
end
