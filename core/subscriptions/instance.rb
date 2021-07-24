module Core
  module Subscriptions
    User = Struct.new(:id, :name)
    Channel = Struct.new(:id, :name)

    class Instance
      def initialize(user:, channel:, servers: [], events: [])
        @user = user
        @channel = channel
        @servers = servers
        @events = events
      end
    end
  end
end
