require_relative '../../src/socket_line_reader'

require 'socket'

class LinePrinter
  def send_line(line)
    puts line
  end
end

if (ARGV.length != 1)
  puts "usage #{$0} [listen socket name]"
  exit
end

socket_filename = ARGV[0]

server = UNIXServer.new(socket_filename)

socket = server.accept
destination = LinePrinter.new
line_reader = SocketLineReader.new(socket, destination)
line_reader.run
