require 'minitest/spec'
require 'minitest/autorun'

require_relative 'distributor'

describe Distributor do
  it 'sends follow event to to: user' do
    user1 = User.new
    user2 = User.new

    event = Event.new(type: :follow, from: user1, to: user2)
    distributor = Distributor.new

    distributor.send(event)

    assert_equal [event], user2.events
  end

  it 'sends unfollow event to to: user' do
    user1 = User.new
    user2 = User.new

    event = Event.new(type: :unfollow, from: user1, to: user2)
    distributor = Distributor.new

    distributor.send(event)

    assert_equal [event], user2.events
  end

  it 'sends private message event to to: user' do
    user1 = User.new
    user2 = User.new
    event = Event.new(type: :message, from: user1, to: user2)
    distributor = Distributor.new

    distributor.send(event)

    assert_equal [event], user2.events
  end
end
