class TwilioService

  def initialize
  end
   
  def send_sms(to, msg)
    @client = Twilio::REST::Client.new
    to = '+' + to unless to[0] == '+'

    message = @client.messages.create(
      from: "+#{Figaro.env.twillio_admin_number}",
      to: to,
      body: msg,
    )
  rescue Twilio::REST::RequestError => ex
    return ex.message
  end
  handle_asynchronously :send_sms
end