require_relative 'event'
require_relative 'event_accumulator'

class Subscriber
  include EventAccumulator
end

class User
  attr_accessor :followers
  attr_accessor :subscribers

  attr_reader :id

  def initialize(id)
    @id = id

    @followers = []
    @subscribers = []
  end

  def send(event)
    update_followers(event)
    notify_subscribers(event)
  end

  private

  def update_followers(event)
    case event.type
    when :follow
      followers.push(event.from)
    when :unfollow
      followers.delete(event.from)
    end
  end

  def notify_subscribers(event)
    if [:message, :broadcast, :follow].include? event.type
      send_to_subscribers(event)
    end
  end

  def send_to_subscribers(event)
      @subscribers.each {|s| s.send(event)}
  end
end
