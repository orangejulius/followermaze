require 'minitest/spec'
require 'minitest/autorun'

require_relative '../src/pipeline_classes'

describe "pipeline" do

  it "allows single step pipeline to work" do
    accumulator = EventAccumulator.new
    step1 = FirstStep.new(accumulator)

    step1.send_event "fake event"

    assert_equal ["fake event"], accumulator.events
  end

  it "allows two step pipeline to work" do
    accumulator = EventAccumulator.new
    step2 = SecondStep.new(accumulator)
    step1 = FirstStep.new(step2)

    step1.send_event "fake event"
    step2.run
    sleep 0.1

    assert_equal ["fake event"], accumulator.events
  end
end
