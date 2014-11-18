class UserConnection
  def initialize(socket)
    @socket = socket
  end

  def get_id
    @socket.readlines(1).first.to_i
  end

  def send_event(event)
    @socket.write(event.payload)
  end
end
