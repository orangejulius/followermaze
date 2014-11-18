# just keeps things in an array
class Accumulator
  attr_accessor :items

  def initialize
    @items = []
  end

  def send_item(item)
    @items.push(item)
  end
end

class EventAccumulator < Accumulator
  alias_method :send_event, :send_item
  alias_method :events, :items
end
