require './core/events/base_storage'

module EventsStorages
  class Memory < Core::Events::BaseStorage
    def initialize
      @events = {}
    end

    def save(event)
      id = SecureRandom.uuid
      @events[id] = event.merge('id' => id, 'processed' => false, 'created_at' => Time.now)
    end

    def unprocessed(limit: nil, order: nil)
      values = @events.values.select { |i| !i['processed'] }
      values = values[0..limit] if limit
      values = values.sort_by { |i| i[order] } if order
      values
    end

    def delete_all(event_ids)
      @events.delete_if { |k, v| event_ids.include?(k) }
    end
  end
end
