require_relative '../../src/event'
require_relative '../../src/user_connection_manager'

require 'socket'

server = TCPServer.new(9989)

manager = UserConnectionManager.new(server, 2)
manager.run

sleep 0.1

event1 = Event.new(1, :message, 3, 1, "hello1")
event2 = Event.new(2, :message, 3, 2, "hello2")

message1 = Message.new(event1, event1.to)
message2 = Message.new(event2, event2.to)

manager.send_message(message1)
manager.send_message(message2)
