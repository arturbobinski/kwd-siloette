class TwilioService

  def initialize
    @client = Twilio::REST::Client.new
  end
   
  def send_sms(to, msg)
    to = to.gsub(/^0/, '').gsub(/-/, '')
    to = '+' + to unless to[0] == '+'

    message = @client.messages.create(
      from: "+#{Figaro.env.twillio_admin_number}",
      to: to,
      body: msg,
    )
  rescue Twilio::REST::RequestError => ex
    return ex.message
  end
end