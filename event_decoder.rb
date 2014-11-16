require_relative 'accumulator'
require_relative 'event'

class EventAccumulator
  include Accumulator
end

class EventDecoder
  def initialize(destination)
    @destination = destination
  end

  def send(input)
    parts = input.split '|'
    sequence = parts[0].to_i
    type = decode_type(parts[1])
    from = decode_user(parts[2])
    to = decode_user(parts[3])

    @destination.send(Event.new(sequence: sequence, type: type, from: from, to: to))
  end

  private

  def decode_type(input)
    case input
    when 'B'
      :broadcast
    when 'F'
      :follow
    end
  end

  def decode_user(input)
    input.to_i unless input.nil?
  end
end
