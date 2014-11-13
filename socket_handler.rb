# really simple class that can be tested with something other than a socket
class SocketHandler
  def initialize(socket)
    @socket = socket
  end

  def run
    @socket.write "Hello"
    @socket.close
  end
end
