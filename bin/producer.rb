require './events_sources/dummy'
require './config'
require './events_storages/mongo'
require './core/events_facade'
require 'mongo'

config = Config.new('config.yml')
mongo_client = client = Mongo::Client.new(config.mongo_url, :database => 'test')

events_storage = EventsStorages::Mongo.new(mongo_client[:events])
events_service = Core::EventsFacade.new(storage: events_storage)

EventsSources::Dummy.new(events_service, servers: config.servers, timeout: 1).process
