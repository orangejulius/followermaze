require 'minitest/spec'
require 'minitest/autorun'

require_relative '../../src/event_decoder'

require_relative '../mocks/accumulator'

describe EventDecoder do
  describe 'parsing broadcast event' do
    def setup
      @input = "123|B"
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send_line(@input)
    end

    it 'sets sequence number and type' do
      assert_equal 1,  @destination.events.size
      assert_equal :broadcast, @destination.events.first.type
      assert_equal 123, @destination.events.first.sequence
    end

    it 'leaves to and from nil' do
      assert_nil @destination.events.first.to
      assert_nil @destination.events.first.from
    end

    it 'sets event payload to raw input string' do
      assert_equal @input, @destination.events.first.payload
    end
  end

  describe 'parsing follow event' do
    def setup
      input = '234|F|5|9'
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send_line(input)
    end

    it 'sets sequence number and type on created event' do
      assert_equal 1, @destination.events.size
      assert_equal :follow, @destination.events.first.type
      assert_equal 234, @destination.events.first.sequence
    end

    it 'sets from user id on created event' do
      assert_equal 5, @destination.events.first.from
    end

    it 'sets to user id on created event' do
      assert_equal 9, @destination.events.first.to
    end
  end

  describe 'parsing unfollow event' do
    it 'sets type to unfollow' do
      input = '562|U|2|3'
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send_line(input)

      assert_equal :unfollow, @destination.events.first.type
    end
  end

  describe 'parsing private message event' do
    it 'sets type to message' do
      input = '2|P|4|5'
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send_line(input)

      assert_equal :message, @destination.events.first.type
    end
  end

  describe 'parsing status update event' do
    it 'sets type to status' do
      input = '9|S|80|1'
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send_line(input)

      assert_equal :status, @destination.events.first.type
    end
  end
end
