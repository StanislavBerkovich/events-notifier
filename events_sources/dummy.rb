module EventsSources
  class Dummy
    SERVERS = ['bitstars_net', 'n1_casino', 'betamo', 's5_css'].freeze

    def initialize(consumer)
      @consumer = consumer
    end

    def process
      while event = take_next
        @consumer.consume(event)
      end
    end

    private

    def take_next
      sleep(1)
      { 'server' => SERVERS.shuffle.first, 'message' => SecureRandom.uuid }
    end
  end
end
