module Core
  module Events
    class BaseStorage
      def save(event)
        raise NotImplementedError
      end

      def unprocessed(limit: nil, order: nil)
        raise NotImplementedError
      end

      def delete_all(event_ids)
        raise NotImplementedError
      end
    end
  end
end
