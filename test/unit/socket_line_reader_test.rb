require 'minitest/spec'
require 'stringio'

require_relative '../../src/socket_line_reader'

class LineAccumulator
  attr_reader :lines

  def initialize()
    @lines = []
  end

  def send_line(line)
    @lines.push(line)
  end
end

describe SocketLineReader do
  it 'sends each line of the socket to the destination' do
    fake_socket = StringIO.new("a\nb\n")
    destination = LineAccumulator.new
    reader = SocketLineReader.new(fake_socket, destination)

    reader.run

    assert_equal ["a\n", "b\n"], destination.lines
  end

  it 'handles CRLF line endings' do
    fake_socket = StringIO.new("a\r\nb\r\n")
    destination = LineAccumulator.new
    reader = SocketLineReader.new(fake_socket, destination)

    reader.run

    assert_equal ["a\r\n", "b\r\n"], destination.lines
  end
end
