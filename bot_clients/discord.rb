require 'discordrb'
require './core/bot_clients/errors'
require './core/bot_clients/base'

module BotClients
  class Discord < Core::BotClients::Base
    module Messages
      SUBSCRIBE_PREFIX = 'AddSub'
      UNSUBSCRIBE = 'UnSubOne'
      UNSUBSCRIBE_ALL = 'UnSubAll'
      LIST = 'SubList'
    end

    def initialize(token:)
      @client = Discordrb::Bot.new(token: token)
    end

    def start
      @client.run
    end

    def handle_subscribe
      @client.message(start_with: Messages::SUBSCRIBE_PREFIX) do |event|
        subscription_json = event.message.to_s.delete_prefix(Messages::SUBSCRIBE_PREFIX)
        subscription = begin
          JSON.parse(subscription_json)
        rescue JSON::ParserError
          raise_invalid_subscription_error("Subscription is invalid JSON")
        end

        subscriptions = yield(subscription, event.channel.id)

        event.respond("Your subscriptions: #{subscriptions.to_json}")
      rescue Core::BotClients::Errors::Base => e
        event.respond("Error: #{e}")
      end
    end

    def handle_unsubscribe_all
      @client.message(with_text: Messages::UNSUBSCRIBE_ALL) do |event|
        subscriptions = yield event.channel.id

        event.respond("Your subscriptions: #{subscriptions.to_json}")
      rescue Core::BotClients::Errors::Base => e
        event.respond("Error: #{e}")
      end
    end

    def handle_unsubscribe
      @client.message(start_with: Messages::UNSUBSCRIBE) do |event|
        id = event.message.to_s.delete_prefix(Messages::UNSUBSCRIBE).strip
        subscriptions = yield id, event.channel.id

        event.respond("Your subscriptions: #{subscriptions.to_json}")
      rescue Core::BotClients::Errors::Base => e
        event.respond("Error: #{e}")
      end
    end

    def handle_subscriptions
      @client.message(with_text: Messages::LIST) do |event|
        subscriptions = yield event.channel.id

        event.respond("Your subscriptions: #{subscriptions.to_json}")
      rescue Core::BotClients::Errors::Base => e
        event.respond("Error: #{e}")
      end
    end

    def send_message(channel_id, text)
      channel = @client.channel(channel_id)
      @client.send_message(channel, text)
    end

    def raise_invalid_subscription_error(message)
      raise Core::BotClients::Errors::InvalidSubscription, message
    end
  end
end
