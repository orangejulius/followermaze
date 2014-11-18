require 'set'

class User
  attr_reader :id
  attr_accessor :followers

  def initialize(id)
    @id = id
    @followers = Set.new
  end
end
