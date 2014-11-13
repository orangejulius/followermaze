require 'minitest/spec'
require 'minitest/autorun'

require_relative 'sequencer'

describe Sequencer do
  it 'sends item #1 immediately' do
    destination = []

    sequencer = Sequencer.new(destination)
    sequencer.send(1)

    assert_equal [1], destination
  end

  it 'does nothing when given 2' do
    destination = []

    sequencer = Sequencer.new(destination)
    sequencer.send(2)

    assert_equal [], destination
  end

  it 'sends 1, then 2, when given 1, 2' do
    destination = []

    sequencer = Sequencer.new(destination)
    sequencer.send(2)
    sequencer.send(1)

    assert_equal [1, 2], destination
  end

  it 'sends 1, 2, 3 when given 3, 2, 1' do
    destination = []

    sequencer = Sequencer.new(destination)
    sequencer.send(3)
    sequencer.send(2)
    sequencer.send(1)

    assert_equal [1, 2, 3], destination
  end

  it 'works for bigger, random arrays' do
    # add zeros to your hearts content :)
    expected = (1..10_000).to_a
    input = expected.shuffle

    destination = []
    sequencer = Sequencer.new(destination)

    input.each do |i|
      sequencer.send(i)
    end

    assert_equal expected, destination
  end
end
