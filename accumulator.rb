# just keeps things in an array
module Accumulator
  attr_accessor :items

  def initialize
    @items = []
  end

  def send(event)
    @items.push(event)
  end
end

