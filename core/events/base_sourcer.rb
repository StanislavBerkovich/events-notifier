module Core
  module Events
    class BaseSourcer
      def initialize(consumer)
        @consumer = consumer
      end

      def process
        raise NotImplementedError
      end
    end
  end
end
