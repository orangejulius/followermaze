class FollowerManager
  def initialize(destination)
    @destination = destination
  end

  def send_event(event)
    case event.type
    when :follow
      event.to.add_follower(event.from)
    when :unfollow
      event.to.remove_follower(event.from)
    end

    @destination.send_event(event)
  end
end
