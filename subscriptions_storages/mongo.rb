require './core/subscriptions/base_storage'

module SubscriptionsStorages
  class Mongo < Core::Subscriptions::BaseStorage
    def initialize(storage_collection)
      @subscriptions = {}
      @id_seq = 0
      @collection = storage_collection
    end

    def add_subscription(subscription, channel_id)
      doc = subscription.merge(channel_id: channel_id.to_s)
      @collection.update_one(doc, { '$set' => doc } , upsert: true)
    end

    def subscriptions(channel_id)
      data = @collection.find({ channel_id: channel_id.to_s }, projection: { _id: 1, servers: 1, events: 1 })
      data.map { |i| { id: i['_id'].to_s, servers: i['servers'], events: i['events'] } }.to_json
    end

    def unsubscribe_all(channel_id)
      @collection.delete_many(channel_id: channel_id.to_s)
    end

    def unsubscribe(subscription_id, channel_id)
      @collection.delete_one(channel_id: channel_id.to_s, _id: BSON::ObjectId(subscription_id))
    end

    def channels_subscribed_for(event)
      @collection.find({ servers: event['server'] }, projection: { channel_id: 1, _id: 0}).flat_map(&:values)
    end
  end
end
