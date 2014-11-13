require 'socket'

require_relative 'socket_handler'

server = TCPServer.new 2000
loop do
  Thread.start(server.accept) do |socket|
    handler = SocketHandler.new(socket)
    handler.run
  end
end
