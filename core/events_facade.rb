module Core
  class EventsFacade
    def initialize(storage:)
      @storage = storage
    end

    def save(event)
      @storage.save(event)
      puts "new event saved: #{event}"
    end

    def process_events_batch
      events = @storage.unprocessed(limit: 1000, order: 'created_at')
      @storage.delete_all(events.map { |i| i['id'] }) if yield(events)
    end
  end
end
