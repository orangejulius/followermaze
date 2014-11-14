require_relative 'user'

class Event
  attr_reader :type
  attr_reader :from
  attr_reader :to

  def initialize(type:, from:, to:)
    @type = type
    @from = from
    @to = to
  end
end

# stub of a Subscriber that just keeps events in an array
class Subscriber
  attr_accessor :events

  def initialize
    @events = []
  end

  def send(event)
    @events.push(event)
  end
end

class Distributor
  def send(event)
    case event.type
    when :follow
      event.to.followers.push(event.from)
    when :unfollow
      event.to.followers.delete(event.from)
    when :message
      event.to.subscribers.each {|s| s.send(event)}
    end
  end
end
