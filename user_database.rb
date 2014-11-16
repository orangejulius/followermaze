class User
  attr_reader :id

  def initialize(id)
    @id = id
  end
end

class UserDatabase
  def initialize()
    @database = {}
  end

  def get(id)
    @database[id] = User.new(id) unless @database[id]
    return @database[id]
  end

  def all
    return @database.values
  end
end
