require_relative 'user'

class Distributor
  def send(event)
    case event.type
    when :follow
      event.to.followers.push(event.from)
    when :unfollow
      event.to.followers.delete(event.from)
    when :message
      event.to.subscribers.each {|s| s.send(event)}
    end
  end
end
