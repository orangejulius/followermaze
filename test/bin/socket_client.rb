require 'socket'


if (ARGV.length != 1)
  puts "usage #{$0} [connect socket name]"
  exit
end

socket_filename = ARGV[0]

socket = UNIXSocket.new(socket_filename)

socket.puts("hello")
socket.puts("hello2")
socket.close
