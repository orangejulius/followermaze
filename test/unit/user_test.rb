require 'minitest/spec'

require_relative '../../src/user'

describe User do
  def setup
    @user1 = User.new(1)
    @user2 = User.new(2)
  end

  it 'requries an id to be initialized' do
    assert_raises ArgumentError do
      User.new
    end

    refute_nil User.new(1)
  end

  it 'allows followers to be added' do
    @user1.add_follower(@user2)

    assert_equal [@user2], @user1.followers
  end

  it 'treats adding the same follower twice as a noop' do
    @user1.add_follower(@user2)
    @user1.add_follower(@user2)

    assert_equal [@user2], @user1.followers
  end

  it 'disallows adding itself as a follower' do
    @user1.add_follower(@user1)

    assert_equal [], @user1.followers
  end

  it 'allows followers to be removed' do
    @user1.add_follower(@user2)
    @user1.remove_follower(@user2)

    assert_equal [], @user1.followers
  end

  it 'treats removal of non-existent follower as a noop' do
    @user1.remove_follower(@user2)

    assert_equal [], @user1.followers
  end
end
