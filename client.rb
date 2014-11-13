require 'socket'

s = TCPSocket.new 'localhost', 2000

puts s.gets
s.close
