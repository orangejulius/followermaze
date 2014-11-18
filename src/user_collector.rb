require_relative 'event'

class UserCollector
  def initialize(destination, user_database)
    @destination = destination
    @user_database = user_database
  end

  def send_event(event)
    @user_database.add(event.to) if event.to
    @user_database.add(event.from) if event.from

    @destination.send_event(event)
  end
end
