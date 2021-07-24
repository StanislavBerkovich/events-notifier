module EventsSources
  class Dummy
    SERVERS = ['bitstars_net', 'n1_casino', 'betamo', 's5_css'].freeze

    def initialize(events_service, servers:, timeout: 1)
      @events_service = events_service
      @servers = servers
      @timeout = timeout
    end

    def process
      while event = take_next
        @events_service.save(event)
        sleep(@timeout)
      end
    end

    private

    def take_next
      { 'server' => @servers.shuffle.first, 'message' => SecureRandom.uuid }
    end
  end
end
