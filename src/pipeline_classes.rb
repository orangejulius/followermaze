class FakeThread
  def self.new
    yield
  end
end

class PipelineStep
  def initialize(destination, executor)
    @destination = destination
    @executor = executor
    @queue = Queue.new
  end

  def send_event(event)
    @queue.push(event)
  end

  def run
    @executor.new do
      begin
        while true do
          event = @queue.pop
          @destination.send_event(process(event))
          if event.downcase == "stop"
            return
          end
        end
      rescue Exception => e
        break
      end
    end
  end
end

class FirstStep < PipelineStep
  def initialize(destination, executor)
    super(destination, executor)
  end

  def process(event)
    event.strip
  end
end

class SecondStep < PipelineStep
  def initialize(destination, executor)
    super(destination, executor)
  end

  def process(event)
    event.upcase
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
