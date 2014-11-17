require 'minitest/spec'
require 'minitest/autorun'

require_relative 'user_connection_manager'

class FakeSocket
  def accept
    "this would actually be a socket connection"
  end
end

class ConnectionCountingFakeSocket < FakeSocket
  @@accept_calls = 0
  def self.accept_calls
    @@accept_calls
  end

  def accept
    @@accept_calls += 1
    super
  end
end

class SocketCheckingUserConnection < UserConnection
  include Minitest::Assertions

  @@creation_count = 0

  def initialize(socket_connection)
    assert_equal "this would actually be a socket connection", socket_connection
    @@creation_count += 1
  end

  def self.creation_count
    @@creation_count
  end
end

class PayloadExpectingUserConnection
  @@send_payload_count = 0
  include Minitest::Assertions

  def initialize(socket_connection)
  end

  def send_payload(payload)
    assert_equal "expected payload", payload
    @@send_payload_count += 1
  end

  def self.send_payload_count
    @@send_payload_count
  end
end

describe UserConnectionManager do
  it 'passes socket connection given by accept to UserConnection class' do
    fake_socket = Minitest::Mock.new
    fake_socket.expect(:accept, "this would actually be a socket connection")

    manager = UserConnectionManager.new(fake_socket, 1, SocketCheckingUserConnection)
    manager.run

    fake_socket.verify
    assert_equal 1, SocketCheckingUserConnection.creation_count
  end

  it 'calls accept up to connection_limit times' do
    fake_socket = ConnectionCountingFakeSocket.new

    connection_limit = 5
    manager = UserConnectionManager.new(fake_socket, connection_limit )
    manager.run

    assert_equal connection_limit, ConnectionCountingFakeSocket.accept_calls
  end

  it 'sends the payload of received messages to the UserConnection' do
    fake_socket = FakeSocket.new

    connection_limit = 5
    manager = UserConnectionManager.new(fake_socket, connection_limit, PayloadExpectingUserConnection)
    manager.run

    message = Message.new(payload: "expected payload", recipient: 10)
    manager.send_message(message)

    assert_equal 1, PayloadExpectingUserConnection.send_payload_count
  end
end
