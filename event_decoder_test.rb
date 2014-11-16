require 'minitest/spec'
require 'minitest/autorun'

require_relative 'event_decoder'

describe EventDecoder do
  describe 'parsing broadcast event' do
    def setup
      input = "123|B"
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send(input)
    end

    it 'sets sequence number and type' do
      assert_equal 1,  @destination.items.size
      assert_equal :broadcast, @destination.items.first.type
      assert_equal 123, @destination.items.first.sequence
    end

    it 'leaves to and from as nil' do
      assert_nil @destination.items.first.to
      assert_nil @destination.items.first.from
    end
  end

  describe 'parsing follow event' do
    def setup
      input = '234|F|5|9'
      @destination = EventAccumulator.new
      @decoder = EventDecoder.new(@destination)

      @decoder.send(input)
    end

    it 'sets sequence number and type on created event' do
      assert_equal 1, @destination.items.size
      assert_equal :follow, @destination.items.first.type
      assert_equal 234, @destination.items.first.sequence
    end

    it 'sets from user id on created event' do
      assert_equal 5, @destination.items.first.from
    end

    it 'sets to user id on created event' do
      assert_equal 9, @destination.items.first.to
    end
  end
end
