require 'set'

class User
  attr_reader :id

  def initialize(id)
    @id = id
    @followers = Set.new
  end

  def add_follower(user)
    @followers.add(user) unless user.id == id
  end

  def remove_follower(user)
    @followers.delete(user)
  end

  def followers
    @followers.to_a
  end
end
