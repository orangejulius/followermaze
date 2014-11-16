require_relative 'accumulator'
require_relative 'event'

# a fake destination for events to be sent to
class EventAccumulator
  include Accumulator
end

# a simple stub implementation of a User class
class User
  attr_reader :id
  attr_accessor :followers

  def initialize(id)
    @id = id
    @followers = []
  end
end

class FollowerManager
  def initialize(destination)
    @destination = destination
  end

  def send(event)
    case event.type
    when :follow
      event.to.followers.push(event.from)
    when :unfollow
      event.to.followers.delete(event.from)
    end

    @destination.send(event)
  end
end
