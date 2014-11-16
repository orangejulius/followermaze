require 'minitest/spec'
require 'minitest/autorun'

require_relative 'follower_manager'

describe FollowerManager do
  def setup
    @destination = EventAccumulator.new
    @follower_manager = FollowerManager.new(@destination)

  end
  it 'forwards event to destination when sent' do
    event = Event.new(type: :broadcast)

    @follower_manager.send(event)

    assert_equal [event], @destination.items
  end

  it 'adds :from user to :to users followers when sent follow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :follow, from: user1, to: user2)

    @follower_manager.send(event)

    assert_equal [user1], user2.followers
  end

  it 'removes :from user from :to users followers when sent unfollow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    user2.followers = [user1]
    event = Event.new(type: :unfollow, from: user1, to: user2)

    @follower_manager.send(event)

    assert_equal [], user2.followers
  end

  it 'updates followers BEFORE forwading event to destination' do
    # check that the followers array is correct when the send method is called
    class FollowerCheckingDestination
      include Minitest::Assertions
      def send(event)
        assert_equal [event.from], event.to.followers
      end
    end

    destination = FollowerCheckingDestination.new
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :follow, from: user1, to: user2)
    follower_manager = FollowerManager.new(destination)

    follower_manager.send(event)
  end
end
