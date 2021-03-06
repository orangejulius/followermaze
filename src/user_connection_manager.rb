require_relative 'message'
require_relative 'user_connection'

class UserConnectionManager
  def initialize(socket, connection_limit, user_connection_class = UserConnection, executor = Thread)
    @socket = socket
    @connection_limit = connection_limit
    @user_connection_class = user_connection_class
    @connections = {}
    @executor = executor
  end

  def run
    connections = 0
    @executor.start do
      while connections < @connection_limit
        connections += 1
        @executor.start(@socket.accept) do |socket_connection|
          connection = @user_connection_class.new socket_connection
          @connections[connection.get_id] = connection
        end
      end
    end
  end

  def send_message(message)
    return unless @connections[message.recipient]
    @connections[message.recipient].send_event(message.event)
  end
end
