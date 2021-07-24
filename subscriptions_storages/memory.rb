require './core/subscriptions/base_storage'

module SubscriptionsStorages
  class Memory < Core::Subscriptions::BaseStorage
    def initialize
      @subscriptions = {}
      @id_seq = 0
    end

    def add_subscription(subscription, channel_id)
      channel_id = channel_id.to_s
      @subscriptions[channel_id] ||= []
      unless @subscriptions[channel_id].any? { |s| s.except('id') == subscription }
        @subscriptions[channel_id] << subscription.merge('id' => @id_seq.to_s)
        @id_seq += 1
      end
    end

    def subscriptions(channel_id)
      channel_id = channel_id.to_s
      @subscriptions[channel_id]&.to_a || []
    end

    def unsubscribe_all(channel_id)
      channel_id = channel_id.to_s
      @subscriptions.delete(channel_id)
    end

    def unsubscribe(subscription_id, channel_id)
      channel_id = channel_id.to_s
      subscription_id = subscription_id.to_s
      return unless @subscriptions[channel_id]

      @subscriptions[channel_id] = @subscriptions[channel_id].reject { |s| s['id'] == subscription_id }
    end

    def channels_subscribed_for(event)
      @subscriptions.each_with_object([]) do |(channel_id, subs), memo|
        if subs.any? { |s| s['servers'].include?(event['server']) }
          memo << channel_id
        end
      end
    end
  end
end
