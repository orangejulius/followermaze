class FakeThread
  def self.new
    yield
  end
end

class FirstStep
  def initialize(destination)
    @destination = destination
  end

  def send_event(event)
    @destination.send_event(event.strip)
  end
end

class SecondStep
  def initialize(destination, executor = Thread)
    @destination = destination
    @executor = executor
    @queue = Queue.new
  end

  def send_event(event)
    @queue.push(event)
  end

  def run
    @executor.new do
      while true do
        begin
          @destination.send_event @queue.pop.upcase
        rescue Exception
          break
        end
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