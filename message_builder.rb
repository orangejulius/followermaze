require_relative 'accumulator'
require_relative 'event'

# a fake destination for created messages to be sent to
class MessageAccumulator
  include Accumulator
end

# a user just needs an id
class User
  attr_reader :id

  def initialize(id)
    @id = id
  end
end

# a message contains an event and a recipient
# there can be many messages for the same event
# (or possibly no messages for an event)
class Message
  attr_reader :event
  attr_reader :recipient

  def initialize(event:, recipient:)
    @event = event
    @recipient = recipient
  end
end

class MessageBuilder
  def initialize(destination)
    @destination = destination
  end

  def send(event)
    message = Message.new(event: event, recipient: event.to)
    @destination.send message
  end
end
