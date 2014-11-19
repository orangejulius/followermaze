require 'minitest/spec'

require_relative '../mocks/accumulator'
require_relative '../../src/user_collector'

describe UserCollector do
  describe 'when passed event with no to/from users' do
    def setup
      @destination = EventAccumulator.new
      @database = Minitest::Mock.new
      @collector = UserCollector.new(@destination, @database)
      @event = Event.new(1, :broadcast)

      @collector.send_event(@event)
    end

    it 'passes event to destination' do
      assert_equal [@event], @destination.events
    end

    it 'adds no users to UserDatabase' do
      @database.verify
    end
  end

  describe 'when passed event with to user' do
    def setup
      @database = Minitest::Mock.new
      @destination = EventAccumulator.new
      @event = Event.new(1, :follow, nil, 1)
      @collector = UserCollector.new(@destination, @database)

      @database.expect(:add, nil, [@event.to])
      @collector.send_event(@event)
    end

    it 'calls add on user database' do
      @database.verify
    end

    it 'passes event to destination' do
      assert_equal [@event], @destination.events
    end
  end

  describe 'when passed event with from user' do
    def setup
      @database = Minitest::Mock.new
      @destination = EventAccumulator.new
      @event = Event.new(1, :follow, 1)
      @collector = UserCollector.new(@destination, @database)

      @database.expect(:add, nil, [@event.from])
      @collector.send_event(@event)
    end

    it 'calls add on user database' do
      @database.verify
    end

    it' passes event to destination' do
      assert_equal [@event], @destination.events
    end
  end
end
