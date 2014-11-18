require 'socket'

socket = TCPSocket.new 'localhost', 9989

if ARGV.size != 1
  puts "usage #{$0} [client id]"
  exit
end

id = ARGV[0]

socket.puts(id)

response = socket.gets

if response == "hello#{id}"
  puts "ok"
end
