class Event
  attr_reader :sequence
  attr_reader :type
  attr_reader :from
  attr_reader :to

  def initialize(sequence:, type:, from: nil, to: nil)
    @sequence = sequence
    @type = type
    @from = from
    @to = to
  end
end
