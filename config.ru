require 'rack'
require 'json'

require './events_sources/dummy'
require './config'
require './events_storages/mongo'
require './core/events_facade'
require 'mongo'

class HttpApp
  def initialize(events_service)
    @events_service = events_service
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.request_method == 'POST' && req.path == '/events'
      event = JSON.parse(req.body.read)
      @events_service.save(event)
      [201, {}, ['Created']]
    else
      [404, {}, ['Not found']]
    end
  end
end

config = Config.new('config.yml')
mongo_client = client = Mongo::Client.new(config.mongo_url, :database => 'test')

events_storage = EventsStorages::Mongo.new(mongo_client[:events])
events_service = Core::EventsFacade.new(storage: events_storage)

run HttpApp.new(events_service)
