require './config'
require './subscriptions_storages/mongo'
require './users_storages/mongo'
require './core/subscriptions_facade'
require './bot_clients/discord'
require 'mongo'

config = Config.new('config.yml')
mongo_client = client = Mongo::Client.new(config.mongo_url)

subscriptions_storage = SubscriptionsStorages::Mongo.new(mongo_client[:subscriptions])
subscriptions_service = Core::SubscriptionsFacade.new(storage: subscriptions_storage)

users_storage = UsersStorages::Mongo.new(mongo_client[:users])

bot_client = BotClients::Discord.new(token: config.discord_bot_token, users_service: users_storage)
bot_client.start_listener(subscriptions_service)
