# a message contains an event and a recipient
# there can be many messages for the same event
# (or possibly no messages for an event)
class Message
  attr_reader :payload
  attr_reader :recipient

  def initialize(payload:, recipient:)
    @payload = payload
    @recipient = recipient
  end
end
