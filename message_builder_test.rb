require 'minitest/spec'
require 'minitest/autorun'

require_relative 'message_builder'

describe MessageBuilder do
  it 'creates one message addressed to :to for private messages' do
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :message, from: user1, to: user2)

    destination = MessageAccumulator.new
    message_builder = MessageBuilder.new(destination)

    message_builder.send(event)

    assert_equal 1, destination.items.size
    assert_equal event, destination.items.first.event
    assert_equal user2, destination.items.first.recipient
  end
end
