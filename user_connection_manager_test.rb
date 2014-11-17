require 'minitest/spec'
require 'minitest/autorun'

require_relative 'user_connection_manager'

describe UserConnectionManager do
  class UserConnection
    # mock version of the class that checks socket connection was passed successfully
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

  it 'passes socket connection given by accept to UserConnection class' do
    fake_socket = Minitest::Mock.new
    fake_socket.expect(:accept, "this would actually be a socket connection")

    manager = UserConnectionManager.new(fake_socket, 1)
    manager.run

    fake_socket.verify
    assert_equal 1, UserConnection.creation_count
  end

  class FakeSocket
    @@accept_calls = 0

    def accept
      @@accept_calls += 1
      "this would actually be a socket connection"
    end

    def self.accept_calls
      @@accept_calls
    end
  end

  it 'calls accept up to connection_limit times' do
    fake_socket = FakeSocket.new

    connection_limit = 5
    manager = UserConnectionManager.new(fake_socket, connection_limit)
    manager.run

    assert_equal connection_limit, FakeSocket.accept_calls
  end
end
