require 'set'

class Sequencer
  def initialize(destination)
    @destination = destination
    @last_sent = 0 # first item to be sent is implied to be 1
    @queue = Set.new # not actually a queue... :/
  end

  def send(item)
    @queue.add(item)
    flush
  end

  def flush
    while @queue.include?(@last_sent + 1) do
      @destination.push @last_sent + 1
      @last_sent += 1
    end
  end
end
