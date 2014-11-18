require_relative 'event'
require_relative 'message'

class MessageBuilder
  def initialize(destination, user_database)
    @destination = destination
    @user_database = user_database
  end

  def send_event(event)
    case event.type
    when :message, :follow
      unicast(event, event.to)
    when :update
      multicast(event, event.from.followers)
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
    recipients.each {|r| unicast(event, r) }
  end
end
