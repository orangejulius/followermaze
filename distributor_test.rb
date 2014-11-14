require 'minitest/spec'
require 'minitest/autorun'

require_relative 'distributor'

describe Distributor do
  it 'does nothing if sent an event when no users are associated' do
    distributor = Distributor.new
    e = Event.new(id: 1, user_id: 1)

    distributor.send(e)
  end

  it 'sends an event to a user if associated with that user' do
    distributor = Distributor.new
    e = Event.new(id: 1, user_id: 1)
    u = User.new(1)

    distributor.add_user(u)

    distributor.send(e)

    assert_equal [e], u.events
  end

  it 'sends an event only to the correct user' do
    distributor = Distributor.new
    e = Event.new(id: 1, user_id: 1)
    u = User.new(1)
    u2 = User.new(2)

    distributor.add_user(u)
    distributor.add_user(u2)

    distributor.send(e)

    assert_equal [], u2.events
  end
end
