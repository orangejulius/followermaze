require 'minitest/spec'

require_relative 'user_database'

describe UserDatabase do
  it 'returns a user given an id' do
    database = UserDatabase.new

    user = database.get(1)

    assert_equal 1, user.id
  end

  it 'returns the same object given the same id twice' do
    database = UserDatabase.new

    user1 = database.get(1)
    user2 = database.get(1)

    assert_same user1, user2
  end

  it 'can return all users' do
    database = UserDatabase.new
    user1 = database.get(1)
    user2 = database.get(2)
    user3 = database.get(3)

    assert_equal [user1, user2, user3], database.all
  end
end
