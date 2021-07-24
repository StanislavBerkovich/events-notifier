require './config'
require './subscriptions_storages/memory'
require './events_storages/memory'
require './bot_clients/discord'
require './events_sources/dummy'
require './events_consumers/sync_bot_sender'
require './core/subscriptions_facade'
require './core/events_facade'

subscriptions_storage = SubscriptionsStorages::Memory.new
subscriptions_service = Core::SubscriptionsFacade.new(storage: subscriptions_storage)

events_storage = EventsStorages::Memory.new
events_service = Core::EventsFacade.new(storage: events_storage)

config = Config.new('config.yml')
bot_client = BotClients::Discord.new(token: config.discord_bot_token)

bot = Thread.new do
  bot_client.start_listener(subscriptions_service)
end

events_producer = Thread.new do
  EventsSources::Dummy.new(events_service, servers: config.servers, timeout: 0.1).process
end

events_consumer = Thread.new do
  events_consumer = EventsConsumers::SyncBotSender.new(subscriptions_service: subscriptions_service,
                                                       events_service: events_service,
                                                       bot_client: bot_client)
  events_consumer.consume
end


[events_producer, bot, events_consumer].each(&:join)
