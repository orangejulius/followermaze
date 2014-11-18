require 'minitest/spec'

require_relative '../../src/user_database'

describe UserDatabase do
  it 'returns a new user from add when given an id' do
    database = UserDatabase.new

    user = database.add(1)

    assert_equal 1, user.id
  end

  it 'returns the same user from add given the same id twice' do
    database = UserDatabase.new

    user1 = database.add(1)
    user2 = database.add(1)

    assert_same user1, user2
  end

  it 'returns a user given an id' do
    database = UserDatabase.new
    database.add(1)

    user = database.get(1)

    assert_equal 1, user.id
  end

  it 'returns the same object given the same id twice' do
    database = UserDatabase.new
    database.add(1)

    user1 = database.get(1)
    user2 = database.get(1)

    assert_same user1, user2
  end

  it 'can return all users' do
    database = UserDatabase.new
    user1 = database.add(1)
    user2 = database.add(2)
    user3 = database.add(3)

    assert_equal [user1, user2, user3], database.all
  end
end
