require 'minitest/spec'
require 'minitest/autorun'

require_relative 'message_builder'

describe MessageBuilder do
  def setup
    @user1 = User.new(1)
    @user2 = User.new(2)

    @destination = MessageAccumulator.new
    @message_builder = MessageBuilder.new(@destination)
  end

  it 'creates one message addressed to :to for private messages' do
    event = Event.new(type: :message, from: @user1, to: @user2)

    @message_builder.send(event)

    assert_equal 1, @destination.items.size
    assert_equal event, @destination.items.first.event
    assert_equal @user2, @destination.items.first.recipient
  end

  it 'creates no messages for an unfollow event' do
    event = Event.new(type: :unfollow, from: @user1, to: @user2)

    @message_builder.send(event)

    assert_equal 0, @destination.items.size
  end
end
