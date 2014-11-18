class UserConnection
  def initialize(socket)
    @socket = socket
  end

  def get_id
    @socket.readlines(1).first.to_i
  end

  def send_payload(string)
    @socket.write(string)
  end
end
