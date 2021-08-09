require 'discordrb'

module BotClients
  class Discord
    module Messages
      SUBSCRIBE_PREFIX = 'AddSub'
      UNSUBSCRIBE = 'UnSubOne'
      UNSUBSCRIBE_ALL = 'UnSubAll'
      LIST = 'SubList'
      HELP = 'help'
    end

    HELP_MESSAGE = <<~MESSAGE.freeze
      :wave: Commands:
      **#{Messages::SUBSCRIBE_PREFIX} <JSON>** - Subscribe to events (example: AddSub { "servers": ["s12_css"] })
      **#{Messages::UNSUBSCRIBE} <SubscriptionID>** - Unubscribe one channel
      **#{Messages::UNSUBSCRIBE_ALL}** - Unubscribe all channels
      **#{Messages::LIST}** - Subscriptions list
    MESSAGE

    def initialize(token:)
      @client = Discordrb::Bot.new(token: token)
    end

    def start_listener(subscriptions_service)
      handle_subscribe(subscriptions_service)
      handle_unsubscribe_all(subscriptions_service)
      handle_unsubscribe(subscriptions_service)
      handle_subscriptions(subscriptions_service)
      handle_help

      @client.run
    end

    def send_message(channel_id, text)
      channel = @client.channel(channel_id)
      @client.send_message(channel, text)
    end

    private

    def handle_subscribe(subscriptions_service)
      @client.message(start_with: Messages::SUBSCRIBE_PREFIX) do |event|
        subscription_json = event.message.to_s.delete_prefix(Messages::SUBSCRIBE_PREFIX)
        subscription = begin
          JSON.parse(subscription_json)
        rescue JSON::ParserError
          event.respond("Error: Subscription is invalid JSON")
          return
        end

        subscriptions_service.subscribe(subscription, event.channel.id)

        event.respond(":ok_hand: Your subscriptions: #{subscriptions_service.list(event.channel.id).to_json}")
      rescue subscriptions_service.class::BaseError => e
        event.respond("Error: #{e}")
      end
    end

    def handle_help
      @client.message(with_text: Messages::HELP) do |event|
        event.respond(HELP_MESSAGE)
      rescue subscriptions_service.class::BaseError => e
        event.respond("Error: #{e}")
      end
    end

    def handle_unsubscribe_all(subscriptions_service)
      @client.message(with_text: Messages::UNSUBSCRIBE_ALL) do |event|
        subscriptions_service.unsubscribe_all(event.channel.id)

        event.respond(":ok_hand: Your subscriptions: #{subscriptions_service.list(event.channel.id).to_json}")
      rescue subscriptions_service.class::BaseError => e
        event.respond("Error: #{e}")
      end
    end

    def handle_unsubscribe(subscriptions_service)
      @client.message(start_with: Messages::UNSUBSCRIBE) do |event|
        id = event.message.to_s.delete_prefix(Messages::UNSUBSCRIBE).strip
        subscriptions_service.unsubscribe(id, event.channel.id)

        event.respond(":ok_hand: Your subscriptions: #{subscriptions_service.list(event.channel.id).to_json}")
      rescue subscriptions_service.class::BaseError => e
        event.respond("Error: #{e}")
      end
    end

    def handle_subscriptions(subscriptions_service)
      @client.message(with_text: Messages::LIST) do |event|
        subscriptions_service.list(event.channel.id)

        event.respond(":ok_hand: Your subscriptions: #{subscriptions_service.list(event.channel.id).to_json}")
      rescue @subscriptions.class::BaseError => e
        event.respond("Error: #{e}")
      end
    end
  end
end
