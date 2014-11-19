require 'minitest/spec'

require_relative '../../src/message_builder'

describe MessageBuilder do
  def setup
    @user_database = UserDatabase.new
    @user1 = @user_database.add(1)
    @user2 = @user_database.add(2)
    @user3 = @user_database.add(3)
    @user4 = @user_database.add(4)

    @destination = MessageAccumulator.new
    @message_builder = MessageBuilder.new(@destination, @user_database)
  end

  it 'creates one message addressed to :to for private messages' do
    event = Event.new(1, :message, @user1.id, @user2.id)

    @message_builder.send_event(event)

    assert_equal 1, @destination.messages.size
    assert_equal event, @destination.messages.first.event
    assert_equal @user2.id, @destination.messages.first.recipient
  end

  it 'creates no messages for an unfollow event' do
    event = Event.new(1, :unfollow, @user1.id, @user2.id)

    @message_builder.send_event(event)

    assert_equal 0, @destination.messages.size
  end

  it 'creates one message addressed to :to for follow event' do
    event = Event.new(1, :follow, @user1.id, @user2.id)

    @message_builder.send_event(event)

    assert_equal 1, @destination.messages.size
    assert_equal event, @destination.messages.first.event
    assert_equal @user2.id, @destination.messages.first.recipient
  end

  it 'creates one message addressed to each follower for status updates' do
    @user1.add_follower @user2
    @user1.add_follower @user3

    event = Event.new(1, :status, @user1.id)

    @message_builder.send_event(event)

    assert_equal @user1.followers.size, @destination.messages.size
    assert_equal [event, event], @destination.messages.map(&:event)
    assert_equal @user1.followers.map(&:id), @destination.messages.map(&:recipient)
  end

  it 'creates a message for every user from brodcast events' do
    event = Event.new(1, :broadcast)

    @message_builder.send_event(event)

    assert_equal @user_database.all.size, @destination.messages.size
  end
end
