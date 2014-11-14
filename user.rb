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
    @subscribers.each {|s| s.send(event)}
    if event.type == :follow
      followers.push(event.from)
    else
      followers.delete(event.from)
    end
  end
end
