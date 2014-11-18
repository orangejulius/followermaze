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
