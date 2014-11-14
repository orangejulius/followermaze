require_relative 'accumulator'
require_relative 'event'

# a fake destination for created messages to be sent to
class MessageAccumulator
  include Accumulator
end

class User
  attr_reader :id
  attr_accessor :followers

  def initialize(id)
    @id = id
    @followers = []
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
    if [:message, :follow].include? event.type
      unicast(event, event.to)
    elsif event.type == :update
      multicast(event, event.from.followers)
    end
  end

  private

  def unicast(event, recipient)
    message = Message.new(event: event, recipient: recipient)
    @destination.send message
  end

  def multicast(event, recipients)
    recipients.each { |r| unicast(event, r) }
  end
end
