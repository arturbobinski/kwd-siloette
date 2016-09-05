require 'twilio-ruby'
require 'sanitize'

module Api
  class SurveysController < Api::BaseController

    before_action :load_address

    def connect_call
      response = Twilio::TwiML::Response.new do |r|
        if @address
          if session[:servey] == 'completed'
            r.Say t('.servey_success'), voice: 'alice', language: 'en-US'
          else
            step = session[:servey]['step'] rescue 0
            num_digits = step > 0 ? 1 : 4

            r.Gather numDigits: num_digits, timeout: 10, finishOnKey: '*', action: '/api/get_answer', method: :get do |g|
              g.Say t('.questions')[step], voice: 'alice', language: 'en-US'
            end
          end
        else
          r.Say t('.invalid_phone'), voice: 'alice', language: 'en-US'
        end
      end

      render text: response.text
    end

    def get_answer
      if session[:servey] && !session[:servey]['booking_id'].nil?
        session[:servey]['step'] += 1
        session[:servey]['score'] << params[:Digits].to_i if session[:servey]['step'] > 0
        complete_servey if session[:servey]['step'] > 3
      else
        if @booking = Booking.find_by(verification_code: params[:Digits].to_i)
          session[:servey] = {
            'booking_id' => @booking.id,
            'step' => 1,
            'score' => []
          }
        end
      end

      redirect_to(action: :connect_call) and return
    end

    private

    def load_address
      @phone_number = Sanitize.clean(params[:From])
      @address = Address.by_phone_number(@phone_number).first
    end

    def complete_servey
      @booking = Booking.find(session[:servey]['booking_id'])
      @service = @booking.service
      @service.testimonials.create(
        author: @booking.user,
        receiver: @service.user,
        delay: session[:servey]['score'][0],
        accuracy: session[:servey]['score'][1],
        satisfaction: session[:servey]['score'][2],
      )
      session[:servey] = 'completed'
    end
  end
end