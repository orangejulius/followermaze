class Event
  attr_reader :type
  attr_reader :from
  attr_reader :to

  def initialize(type:, from:, to:)
    @type = type
    @from = from
    @to = to
  end
end
