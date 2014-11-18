class Sequencer
  def initialize(destination)
    @destination = destination
    # while not a queue in a data structure sense,
    # this is where events are queued up to be sent
    @queue = {}
    @next_sequence = 1
  end

  def send_event(event)
    @queue[event.sequence] = event
    flush
  end

  private

  def flush
    while event = @queue.delete(@next_sequence)
      @destination.send_event event
      @next_sequence += 1
    end
  end
end
