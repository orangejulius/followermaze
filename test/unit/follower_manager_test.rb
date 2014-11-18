require 'minitest/spec'
require 'minitest/autorun'

require_relative '../../src/follower_manager'

describe FollowerManager do
  def setup
    @user_database = UserDatabase.new
    @destination = EventAccumulator.new
    @follower_manager = FollowerManager.new(@destination, @user_database)

  end
  it 'forwards event to destination when sent' do
    event = Event.new(type: :broadcast, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [event], @destination.events
  end

  it 'adds :from user to :to users followers when sent follow event' do
    user1 = @user_database.add(1)
    user2 = @user_database.add(2)
    event = Event.new(type: :follow, from: 1, to: 2, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [user1], user2.followers
  end

  it 'removes :from user from :to users followers when sent unfollow event' do
    user1 = @user_database.add(1)
    user2 = @user_database.add(2)
    user2.add_follower user1
    event = Event.new(type: :unfollow, from: 1, to: 2, sequence: 1)

    @follower_manager.send_event(event)

    assert_equal [], user2.followers
  end

  it 'updates followers BEFORE forwading event to destination' do
    # check that the followers array is correct when the send method is called
    class FollowerCheckingDestination
      include Minitest::Assertions

      def initialize(user_database)
        @user_database = user_database
      end
      def send_event(event)
        to = @user_database.get(event.to)
        from = @user_database.get(event.from)
        assert_equal [from], to.followers
      end
    end

    destination = FollowerCheckingDestination.new(@user_database)
    user1 = @user_database.add(1)
    user2 = @user_database.add(2)
    event = Event.new(type: :follow, from: 1, to: 2, sequence: 1)
    follower_manager = FollowerManager.new(destination, @user_database)

    follower_manager.send_event(event)
  end
end
