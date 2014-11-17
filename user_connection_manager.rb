require_relative 'message'

class UserConnection
  def initialize(socket_connection)
  end

  def get_id
  end
end

class UserConnectionManager
  def initialize(socket, connection_limit, user_connection_class = UserConnection)
    @socket = socket
    @connection_limit = connection_limit
    @user_connection_class = user_connection_class
    @connections = {}
  end

  def run
    connections = 0
    while connections < @connection_limit
      connections += 1
      Thread.start(@socket.accept) do |socket_connection|
        connection = @user_connection_class.new socket_connection
        @connections[connection.get_id] = connection
      end
    end
  end

  def send_message(message)
    @connections[message.recipient].send_payload(message.payload)
  end
end
