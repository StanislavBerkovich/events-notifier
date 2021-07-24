require './config'
require './subscriptions_storages/memory'
require './core/bot_processor'
require './bot_clients/discord'
require './events_sources/dummy'
require './events_consumers/sync_bot_sender'

subscriptions_storage = SubscriptionsStorages::Memory.new

bot = Thread.new do
  config = Config.new('config.yml')
  bot_client = BotClients::Discord.new(token: config.discord_bot_token)

  processor = Core::BotProcessor.new(client: bot_client, subscriptions_storage: subscriptions_storage)
  processor.start
end

events_fetcher = Thread.new do
  config = Config.new('config.yml')
  bot_client = BotClients::Discord.new(token: config.discord_bot_token)
  events_consumer = EventsConsumers::SyncBotSender.new(subscriptions_storage: subscriptions_storage, bot_client: bot_client)

  events_source = EventsSources::Dummy.new(events_consumer)
  events_source.process
end


[events_fetcher, bot].each(&:join)
