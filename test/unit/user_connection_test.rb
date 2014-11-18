require 'minitest/spec'
require 'stringio'

require_relative '../../src/user_connection'

describe UserConnection do
  it 'writes payload to socket when given payload' do
    payload = "this would actually be an event"
    socket = StringIO.new
    connection = UserConnection.new(socket)

    connection.send_payload(payload)

    assert_equal payload, socket.string
  end

  it 'returns id from client (might block) when asked for id' do
    socket = StringIO.new
    socket.write("5")
    socket.rewind
    connection = UserConnection.new(socket)

    assert_equal 5, connection.get_id
  end
end
