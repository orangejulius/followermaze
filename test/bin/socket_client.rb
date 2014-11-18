require 'socket'

socket = TCPSocket.new 'localhost', 9998

socket.puts("hello")
socket.puts("hello2")
socket.close
