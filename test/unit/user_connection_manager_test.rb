require 'minitest/spec'

require_relative '../../src/user_connection_manager'

class FakeUserConnection
  def initialize(socket_connection)
  end

  def get_id
  end
end

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

class SocketCheckingUserConnection < FakeUserConnection
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

class EventTrackingUserConnection < FakeUserConnection
  @@next_id = 1
  @@events = {}

  def initialize(socket_connection)
    @id = @@next_id
    @@next_id += 1
  end

  def get_id
    @id
  end

  def send_event(event)
    @@events[@id] = event
  end

  def self.get_events
    @@events
  end
end

class EventExpectingUserConnection < FakeUserConnection
  @@send_event_count = 0
  include Minitest::Assertions

  def initialize(socket_connection)
  end

  def send_event(event)
    assert_equal "expected event", event
    @@send_event_count += 1
  end

  def self.send_event_count
    @@send_event_count
  end
end

describe UserConnectionManager do
  it 'passes socket connection given by accept to UserConnection class' do
    fake_socket = Minitest::Mock.new
    fake_socket.expect(:accept, "this would actually be a socket connection")

    manager = UserConnectionManager.new(fake_socket, 1, SocketCheckingUserConnection)
    manager.run

    sleep(0.01) # wait for connection to be established
    fake_socket.verify
    assert_equal 1, SocketCheckingUserConnection.creation_count
  end

  it 'calls accept up to connection_limit times' do
    fake_socket = ConnectionCountingFakeSocket.new

    connection_limit = 5
    manager = UserConnectionManager.new(fake_socket, connection_limit, FakeUserConnection)
    manager.run

    assert_equal connection_limit, ConnectionCountingFakeSocket.accept_calls
  end

  it 'sends the event of received messages to the correct UserConnection' do
    fake_socket = FakeSocket.new

    connection_limit = 15
    manager = UserConnectionManager.new(fake_socket, connection_limit, EventTrackingUserConnection)
    manager.run

    message = Message.new(event: "fake event", recipient: 10)
    sleep(0.01) # wait for connection to be established
    manager.send_message(message)

    expected = { 10 => "fake event" }
    assert_equal expected, EventTrackingUserConnection.get_events
  end
end
