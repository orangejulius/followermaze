require 'socket'

server = TCPServer.new 2000
loop do
  Thread.start(server.accept) do |socket|
    socket.puts "Hi"
    socket.close
  end
end
