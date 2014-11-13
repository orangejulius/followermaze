require 'socket'

server = TCPServer.new 2000
loop do
  socket = server.accept
  socket.puts "Hi"
  socket.close
end
