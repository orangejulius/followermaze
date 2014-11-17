class SocketLineReader
  def initialize(socket, destination)
    @socket = socket
    @destination = destination
  end

  def run
    while line = @socket.gets
      @destination.send_line(line)
    end
  end
end
