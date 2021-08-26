require './core/subscriptions/base_storage'

module UsersStorages
  class Mongo
    def initialize(storage_collection)
      @collection = storage_collection
    end

    def add(chat:, user_id:, channel_id:, name:, email:)
      user = { chat: chat, user_id: user_id, channel_id: channel_id, name: name, email: email }
      @collection.update_one(user, { '$set' => user } , upsert: true)
    end

    def get(chat:, user_id: nil, email: nil)
      @collection.find({user_id: user_id, chat: chat, email: email}.compact)
    end
  end
end
