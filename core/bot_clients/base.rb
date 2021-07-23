module Core
  module BotClients
    class Base
      def start
        raise NotImplementedError
      end

      def handle_subscribe
        raise NotImplementedError
      end

      def handle_unsubscribe_all
        raise NotImplementedError
      end

      def handle_unsubscribe
        raise NotImplementedError
      end

      def handle_subscriptions
        raise NotImplementedError
      end

      def send_message(channel_id, text)
        raise NotImplementedError
      end

      def raise_invalid_subscription_error(message)
        raise Errors::InvalidSubscription, message
      end
    end
  end
end
