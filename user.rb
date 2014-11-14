require_relative 'event'
require_relative 'subscriber'

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
    case event.type
    when :follow
      @subscribers.each {|s| s.send(event)}
      followers.push(event.from)
    when :unfollow
      followers.delete(event.from)
    when :broadcast
      @subscribers.each {|s| s.send(event)}
    when :message
      @subscribers.each {|s| s.send(event)}
    end
  end
end
