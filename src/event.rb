class Event
  attr_reader :sequence
  attr_reader :type
  attr_reader :from
  attr_reader :to
  attr_reader :payload

  def initialize(sequence = nil, type =  nil, from =  nil, to =  nil, payload = nil)
    @sequence = sequence
    @type = type
    @from = from
    @to = to
    @payload = payload
  end
end
