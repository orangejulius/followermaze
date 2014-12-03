require 'minitest/spec'
require 'minitest/autorun'

require_relative '../src/pipeline_classes'

describe "pipeline" do
  it "allows single step pipeline to work" do
    accumulator = EventAccumulator.new
    step1 = FirstStep.new(accumulator, FakeThread)

    step1.send_event "fake event"
    step1.run
    step1.send_event :stop

    assert_equal ["fake event"], accumulator.events
  end

  it "allows two step pipeline to work" do
    accumulator = EventAccumulator.new
    step2 = SecondStep.new(accumulator, FakeThread)
    step1 = FirstStep.new(step2, FakeThread)

    step1.send_event "fake event  "
    step1.send_event "stop"
    step1.run
    step2.run

    assert_equal ["FAKE EVENT", "STOP"], accumulator.events
  end
end
