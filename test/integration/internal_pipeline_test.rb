require 'minitest/spec'
require 'minitest/autorun'

Dir["./src/*.rb"].each {|file| require file }
require_relative '../mocks/accumulator'

describe 'internal pipeline' do
  def setup
    @message_accumulator = MessageAccumulator.new

    @user_database = UserDatabase.new

    @message_builder = MessageBuilder.new(@message_accumulator, @user_database)
    @follower_manager = FollowerManager.new(@message_builder, @user_database)
    @user_collector = UserCollector.new(@follower_manager, @user_database)
    @sequencer = Sequencer.new(@user_collector)
    @event_decoder = EventDecoder.new(@sequencer)
  end

  it 'creates no messages when an initial broadcast is sent' do
    input = '1|B'
    @event_decoder.send_line(input)

    assert_equal [], @message_accumulator.messages
  end

  it 'creates one message and two users from follow event' do
    input = '1|F|1|2'

    @event_decoder.send_line(input)

    assert_equal [2,1], @user_database.all.map(&:id)
    assert_equal 1, @message_accumulator.messages.size
    assert_equal input, @message_accumulator.messages.first.event.payload
    assert_equal :follow, @message_accumulator.messages.first.event.type
  end

  it 'creates two messages from a follow and status update event' do
    input1 = '1|F|3|4'
    input2 = '2|S|4'

    @event_decoder.send_line(input1)

    # first event should cause followers for user 4 to be updated
    assert_equal 3, @user_database.get(4).followers.first.id
    assert_equal 1, @message_accumulator.messages.size

    @event_decoder.send_line(input2)

    #second event should send status update notification message to user 3
    assert_equal 2, @message_accumulator.messages.size
    assert_equal 3, @message_accumulator.messages.last.recipient
    assert_equal :status, @message_accumulator.messages.last.event.type
  end

  it 'creates three messages for a private message followed by a broadcast' do
    input1 = '1|P|10|15'
    input2 = '2|B'

    @event_decoder.send_line(input1)
    @event_decoder.send_line(input2)

    assert_equal 3, @message_accumulator.messages.size
    assert_equal [:message, :broadcast, :broadcast], @message_accumulator.messages.map(&:event).map(&:type)
    assert_equal 2, @user_database.all.size
  end

  it 'creates only one message for a follow, unfollow, status update' do
    input1 = '1|F|50|51'
    input2 = '2|U|50|51'
    input3 = '3|S|51'

    @event_decoder.send_line(input1)
    @event_decoder.send_line(input2)
    @event_decoder.send_line(input3)

    assert_equal [:follow], @message_accumulator.messages.map(&:event).map(&:type)
  end

  it 'creates no messages for a set of events missing sequence #1' do
    input1 = '20|F|1|2'
    input2 = '21|B|1|2'

    @event_decoder.send_line(input1)
    @event_decoder.send_line(input2)

    assert_equal 0, @message_accumulator.messages.size
  end

  it 'handles events coming out of order the same as in order' do
    input1 = '1|F|50|51'
    input2 = '2|U|50|51'
    input3 = '3|S|51'

    @event_decoder.send_line(input3)
    @event_decoder.send_line(input2)
    @event_decoder.send_line(input1)

    assert_equal [:follow], @message_accumulator.messages.map(&:event).map(&:type)
  end
end
