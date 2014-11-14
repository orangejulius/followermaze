require 'minitest/spec'
require 'minitest/autorun'

require_relative 'distributor'

describe Distributor do
  it 'adds a follower to user when given follower event' do
    user1 = User.new(1)
    user2 = User.new(2)

    event = Event.new(type: :follow, from: user1, to: user2)
    distributor = Distributor.new

    distributor.send(event)

    assert_equal [user1], user2.followers
  end

  it 'removes a follower from user when given unfollow event' do
    user1 = User.new(1)
    user2 = User.new(2)
    user2.followers = [user1]

    event = Event.new(type: :unfollow, from: user1, to: user2)
    distributor = Distributor.new

    distributor.send(event)

    assert_equal [], user2.followers
  end

  it 'forwards private message event to to user subscriber' do
    user1 = User.new(1)
    user2 = User.new(2)
    subscriber = Subscriber.new
    event = Event.new(type: :message, from: user1, to: user2)
    distributor = Distributor.new
    user2.subscribers.push(subscriber)

    distributor.send(event)

    assert_equal [event], subscriber.events
  end
end
