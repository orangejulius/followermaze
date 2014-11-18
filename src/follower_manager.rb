class FollowerManager
  def initialize(destination, user_database)
    @destination = destination
    @user_database = user_database
  end

  def send_event(event)
    to = @user_database.get(event.to)
    from = @user_database.get(event.from)

    case event.type
    when :follow
      to.add_follower(from)
    when :unfollow
      to.remove_follower(from)
    end

    @destination.send_event(event)
  end
end
