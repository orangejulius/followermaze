require 'minitest/spec'
require 'minitest/autorun'

require 'stringio'

require_relative 'socket_handler'

describe SocketHandler do
  def setup
    @fake_socket = StringIO.new
    @handler = SocketHandler.new(@fake_socket)
    @handler.run
  end

  it 'should write hello to a passed socket (or io object)' do
    assert_equal "Hello", @fake_socket.string
  end

  it 'should close the connection when done' do
    assert @fake_socket.closed?
  end
end
