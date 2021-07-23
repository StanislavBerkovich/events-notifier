module Core
  module Events
    class BaseConsumer
      def consume(event)
        raise NotImplementedError
      end
    end
  end
end
