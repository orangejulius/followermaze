require_relative 'event'

class EventDecoder
  def initialize(destination)
    @destination = destination
  end

  def send_line(input)
    parts = input.split '|'
    sequence = parts[0].to_i
    type = decode_type(parts[1].chomp)
    from = decode_user(parts[2])
    to = decode_user(parts[3])

    @destination.send_event(Event.new(sequence, type, from, to, input))
  end

  private

  def decode_type(input)
    case input
    when 'B'
      :broadcast
    when 'F'
      :follow
    when 'U'
      :unfollow
    when 'P'
      :message
    when 'S'
      :status
    end
  end

  def decode_user(input)
    input.to_i unless input.nil?
  end
end
