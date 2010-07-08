class Notifier < ActionMailer::Base
  def feedback(sender, message)
    recipients "scottp@berkeleyzone.net"
    from sender
    subject "[retouch] #{message[0,40]}"
    body(:sender => sender, :message => message)
  end

end
