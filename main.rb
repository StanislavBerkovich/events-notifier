require './config'
require './subscriptions_storages/memory'
require './bot_clients/discord'
require './events_sources/dummy'
require './events_consumers/sync_bot_sender'
require './core/subscriptions_facade'

subscriptions_storage = SubscriptionsStorages::Memory.new
subscriptions_service = Core::SubscriptionsFacade.new(storage: subscriptions_storage)

bot = Thread.new do
  config = Config.new('config.yml')
  bot_client = BotClients::Discord.new(token: config.discord_bot_token)
  bot_client.start_listener(subscriptions_service)
end

events_fetcher = Thread.new do
  config = Config.new('config.yml')
  bot_client = BotClients::Discord.new(token: config.discord_bot_token)
  events_consumer = EventsConsumers::SyncBotSender.new(subscriptions_service: subscriptions_service, bot_client: bot_client)

  events_source = EventsSources::Dummy.new(events_consumer)
  events_source.process
end


[events_fetcher, bot].each(&:join)
