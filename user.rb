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
end
