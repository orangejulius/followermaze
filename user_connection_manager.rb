class UserConnectionManager
  def initialize(socket, connection_limit)
    @socket = socket
    @connection_limit = connection_limit
  end

  def run
    connections = 0
    while connections < @connection_limit
      UserConnection.new(@socket.accept)
      connections += 1
    end
  end
end
