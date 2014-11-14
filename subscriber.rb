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

