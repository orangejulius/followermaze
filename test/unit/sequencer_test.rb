require 'minitest/spec'

require_relative '../mocks/accumulator'

require_relative '../../src/event'
require_relative '../../src/sequencer'

describe Sequencer do
  it 'sends event #1 immediately' do
    destination = EventAccumulator.new

    event = Event.new(sequence: 1, type: :broadcast)
    sequencer = Sequencer.new(destination)
    sequencer.send_event(event)

    assert_equal [event], destination.events
  end

  it 'does nothing when given event #2' do
    destination = EventAccumulator.new

    event = Event.new(sequence: 2, type: :broadcast)
    sequencer = Sequencer.new(destination)
    sequencer.send_event(event)

    assert_equal [], destination.events
  end

  it 'sends events #1, #2, #3 when given #3, #2, #1' do
    destination = EventAccumulator.new
    sequencer = Sequencer.new(destination)
    event3 = Event.new(sequence: 3, type: :broadcast)
    event2 = Event.new(sequence: 2, type: :broadcast)
    event1 = Event.new(sequence: 1, type: :broadcast)

    sequencer.send_event(event3)
    sequencer.send_event(event2)
    sequencer.send_event(event1)

    assert_equal [event1, event2, event3], destination.events
  end
end
