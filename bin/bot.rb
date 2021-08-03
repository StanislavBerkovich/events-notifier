require './config'
require './subscriptions_storages/mongo'
require './core/subscriptions_facade'
require './bot_clients/discord'
require 'mongo'

config = Config.new('config.yml')
mongo_client = client = Mongo::Client.new(config.mongo_url, :database => 'test')

subscriptions_storage = SubscriptionsStorages::Mongo.new(mongo_client[:subscriptions])
subscriptions_service = Core::SubscriptionsFacade.new(storage: subscriptions_storage)

bot_client = BotClients::Discord.new(token: config.discord_bot_token)
bot_client.start_listener(subscriptions_service)
