class Event
  attr_accessor :id
  attr_accessor :user_id

  def initialize(id:, user_id:)
    @id = id
    @user_id = user_id
  end
end

class User
  attr_reader :events
  attr_reader :id

  def initialize(id)
    @id = id
    @events = []
  end

  def send(event)
    @events.push(event)
  end
end

class Distributor
  attr_accessor :users

  def initialize
    @users = {}
  end

  def send(event)
    if user = @users[event.user_id]
      user.send(event)
    end
  end

  def add_user(user)
    @users[user.id] = user
  end
end
