module BotClients
  module Errors
    Base = Class.new(StandardError)
    InvalidSubscription = Class.new(Base)
  end
end
