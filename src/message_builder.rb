require_relative 'event'
require_relative 'message'

class MessageBuilder
  def initialize(destination, user_database)
    @destination = destination
    @user_database = user_database
  end

  def send_event(event)
    to = @user_database.get(event.to)
    from = @user_database.get(event.from)
    case event.type
    when :message, :follow
      unicast(event, to.id)
    when :status
      multicast(event, from.followers)
    when :broadcast
      multicast(event, @user_database.all)
    end
  end

  private

  def unicast(event, recipient)
    message = Message.new(event: event, recipient: recipient)
    @destination.send_message message
  end

  def multicast(event, recipients)
    recipients.map(&:id).each {|r| unicast(event, r) }
  end
end
