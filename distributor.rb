require_relative 'event'
require_relative 'event_accumulator'

class User
  include EventAccumulator
end

class Distributor
  def send(event)
    if event.type == :update
      event.from.send(event)
    else
      event.to.send(event)
    end
  end
end
