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
      message = Message.new(event: event, recipient: event.to)
      @destination.send message
    elsif event.type == :update
      event.from.followers.each do |follower|
        message = Message.new(event: event, recipient: follower)
        @destination.send message
      end
    end
  end
end
