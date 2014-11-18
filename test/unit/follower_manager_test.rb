require 'minitest/spec'
require 'minitest/autorun'

require_relative '../../src/follower_manager'

describe FollowerManager do
  def setup
    @destination = EventAccumulator.new
    @follower_manager = FollowerManager.new(@destination)

  end
  it 'forwards event to destination when sent' do
    event = Event.new(type: :broadcast, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [event], @destination.events
  end

  it 'adds :from user to :to users followers when sent follow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :follow, from: user1, to: user2, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [user1], user2.followers
  end

  it 'removes :from user from :to users followers when sent unfollow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    user2.add_follower user1
    event = Event.new(type: :unfollow, from: user1, to: user2, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [], user2.followers
  end

  it 'updates followers BEFORE forwading event to destination' do
    # check that the followers array is correct when the send method is called
    class FollowerCheckingDestination
      include Minitest::Assertions
      def send_event(event)
        assert_equal [event.from], event.to.followers
      end
    end

    destination = FollowerCheckingDestination.new
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :follow, from: user1, to: user2, sequence: 1)
    follower_manager = FollowerManager.new(destination)

    follower_manager.send_event(event)
  end
end
