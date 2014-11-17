require_relative 'message'

class UserConnection
  def initialize(socket_connection)
  end
end

class UserConnectionManager
  def initialize(socket, connection_limit, user_connection_class = UserConnection)
    @socket = socket
    @connection_limit = connection_limit
    @user_connection_class = user_connection_class
  end

  def run
    connections = 0
    while connections < @connection_limit
      @connection = @user_connection_class.new(@socket.accept)
      connections += 1
    end
  end

  def send_message(message)
    @connection.send_payload(message.payload)
  end
end
