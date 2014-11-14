# just keeps events in an array
module EventAccumulator
  attr_accessor :events

  def initialize
    @events = []
  end

  def send(event)
    @events.push(event)
  end
end
