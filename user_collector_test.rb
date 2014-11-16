require 'minitest/spec'

require_relative 'accumulator'
require_relative 'user_collector'

class EventAccumulator
  include Accumulator
end

describe UserCollector do
  describe 'when passed event with no to/from users' do
    def setup
      @destination = EventAccumulator.new
      @database = Minitest::Mock.new
      @collector = UserCollector.new(@destination, @database)
      @event = Event.new(type: :broadcast, sequence: 1)

      @collector.send_event(@event)
    end

    it 'passes event to destination' do
      assert_equal [@event], @destination.items
    end

    it 'adds no users to UserDatabase' do
      @database.verify
    end
  end

  describe 'when passed event with to user' do
    def setup
      @database = Minitest::Mock.new
      @destination = EventAccumulator.new
      @event = Event.new(type: :follow, to: 1, sequence: 1)
      @collector = UserCollector.new(@destination, @database)

      @database.expect(:add, nil, [@event.to])
      @collector.send_event(@event)
    end

    it 'calls add on user database' do
      @database.verify
    end

    it 'passes event to destination' do
      assert_equal [@event], @destination.items
    end
  end
end
