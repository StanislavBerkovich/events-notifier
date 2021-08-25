require './core/subscriptions/base_storage'

module SubscriptionsStorages
  class Mongo < Core::Subscriptions::BaseStorage
    BASE_OR_SELECTORS = { servers: 'server', types: 'type', teams: 'team' }

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
      data.to_a.to_json
    end

    def unsubscribe_all(channel_id)
      @collection.delete_many(channel_id: channel_id.to_s)
    end

    def unsubscribe(subscription_id, channel_id)
      @collection.delete_one(channel_id: channel_id.to_s, _id: BSON::ObjectId(subscription_id))
    end

    def channels_subscribed_for(event)
      and_query = BASE_OR_SELECTORS.map { |k, v| or_selector(k, event[v]) if event[v] }.compact
      if event['subjects'].is_a?(Array)
        and_query += [{ '$or': [{ subjects: { '$exists': false } }, { subjects: { '$in': event['subjects'] } }]}]
      end
      @collection.find({ '$and': and_query } ,
                       projection: { channel_id: 1, _id: 0}).flat_map(&:values)
    end

    private

    def or_selector(field, value)
      { '$or': [{field => value}, {field => { '$exists': false} }] }
    end
  end
end
