require './core/events/base_storage'

module EventsStorages
  class Mongo < Core::Events::BaseStorage
    def initialize(collection)
      @events = {}
      @collection = collection
    end

    def save(event)
      doc = event.merge('created_at' => Time.now)
      @collection.update_one(doc, { '$set' => doc.merge('processed' => false) } , upsert: true)
    end

    def unprocessed(limit: nil, order: nil)
      q = { '$query': { processed: false } }
      q = q.merge('$sort': { order => 1 }) if order
      q = q.merge('$limit': limit) if limit

      @collection.find(q).map { |i| i.merge(id: i['_id'].to_s) }
    end

    def delete_all(event_ids)
      event_ids = event_ids.map { |i| BSON::ObjectId(i) }
      @collection.delete_many('_id': { '$in': event_ids })
    end
  end
end
