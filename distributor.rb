require_relative 'event'
require_relative 'event_accumulator'

class User
  include EventAccumulator
end

class Distributor
  def send(event)
    event.to.send(event)
  end
end
