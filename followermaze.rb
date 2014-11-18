require 'socket'

Dir["./src/*.rb"].each {|file| require file }

event_source_socket = TCPServer.new 9090
user_client_socket = TCPServer.new 9099

user_database = UserDatabase.new

user_connection_manager = UserConnectionManager.new(user_client_socket, 10000000000)
message_builder = MessageBuilder.new(user_connection_manager, user_database)
follower_manager = FollowerManager.new(message_builder, user_database)
user_collector = UserCollector.new(follower_manager, user_database)
sequencer = Sequencer.new(user_collector)
event_decoder = EventDecoder.new(sequencer)

user_connection_manager.run

event_source_connection = event_source_socket.accept
socket_line_reader = SocketLineReader.new(event_source_connection, event_decoder)
socket_line_reader.run
