class FirstStep
  def initialize(destination)
    @destination = destination
  end

  def send_event(event)
    # do nothing, just forward it on
    @destination.send_event(event)
  end
end

class SecondStep
  def initialize(destination)
    @destination = destination
    @queue = Queue.new
  end

  def send_event(event)
    @queue.push(event)
  end

  def run
    Thread.new do
      while true do
        @destination.send_event @queue.pop
      end
    end
  end
end

class EventAccumulator
  attr_reader :events

  def initialize
    @events = []
  end

  def send_event(event)
    @events << event
  end
end
