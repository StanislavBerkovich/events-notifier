require './config'
require './events_consumers/sync_bot_sender'
require './core/subscriptions_facade'
require './subscriptions_storages/mongo'
require './events_storages/mongo'
require './core/events_facade'
require './bot_clients/discord'
require './users_storages/mongo'

require 'mongo'

config = Config.new('config.yml')
mongo_client = client = Mongo::Client.new(config.mongo_url)

subscriptions_storage = SubscriptionsStorages::Mongo.new(mongo_client[:subscriptions])
subscriptions_service = Core::SubscriptionsFacade.new(storage: subscriptions_storage)

events_storage = EventsStorages::Mongo.new(mongo_client[:events])
events_service = Core::EventsFacade.new(storage: events_storage)

users_storage = UsersStorages::Mongo.new(mongo_client[:users])
bot_client = BotClients::Discord.new(token: config.discord_bot_token, users_service: users_storage)

events_consumer = EventsConsumers::SyncBotSender.new(
  subscriptions_service: subscriptions_service,
  events_service: events_service,
  bot_client: bot_client
)
events_consumer.consume
