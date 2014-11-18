require_relative '../../src/socket_line_reader'

require 'socket'

class LinePrinter
  def send_line(line)
    puts line
  end
end

server = TCPServer.new(9998)

socket = server.accept
destination = LinePrinter.new
line_reader = SocketLineReader.new(socket, destination)
line_reader.run
