require 'minitest/spec'
require 'minitest/autorun'

require_relative 'user'

describe User do
  describe 'receiving events' do
    it 'sends broadcasts to all subscribers' do
      subscriber = Subscriber.new
      user = User.new(1)
      user.subscribers.push(subscriber)

      event = Event.new(type: :broadcast)

      user.send(event)

      assert_equal [event], subscriber.events
    end
  end

  it 'adds follower when sent follow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :follow, from: user2, to: user1)

    user1.send(event)

    assert_equal [user2], user1.followers
  end

  it 'removes follower when sent unfollow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    event = Event.new(type: :unfollow, from: user2, to: user1)
    user1.followers = [user2]

    user1.send(event)

    assert_equal [], user1.followers
  end

  it 'notifies subscribers when sent private message' do
      subscriber = Subscriber.new
      user1 = User.new(1)
      user2 = User.new(2)
      user1.subscribers.push(subscriber)

      event = Event.new(type: :message, to: user1, from: user2)

      user1.send(event)

      assert_equal [event], subscriber.events
  end
end
