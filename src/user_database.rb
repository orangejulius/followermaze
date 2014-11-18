require_relative 'user'

class UserDatabase
  def initialize()
    @database = {}
  end

  def add(id)
    @database[id] ||= User.new(id)
  end

  def get(id)
    @database[id]
  end

  def all
    @database.values
  end
end
