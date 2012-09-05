class Notifier < ActionMailer::Base

  def contacted(message)
    from    = "#{message.name.titleize} <#{message.email}>"
    to      = ENV["CONTACT_EMAIL"]
    subject = "[pickingwords-contact] #{message.subject}"
    @body   = message.body

    mail from: from, to: to, subject: subject
  end

end
