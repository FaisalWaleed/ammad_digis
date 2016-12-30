class Stripe::SubscriptionsController < ApplicationController
  protect_from_forgery except: [ :callback ]
  
  before_action :verify_event
  
  def callback
    if params[:data] && params[:data][:object]
      customer_id = params[:data][:object][:customer] rescue nil
      status = params[:data][:status] rescue nil

      if params[:type] == 'charge.succeeded'
        @subscription = ::Subscription.valid.find_by(merchant_customer_id: customer_id)
        
        if @subscription
          @recent_payments = @subscription.payments.recent
          
          if @recent_payments.length.zero?
            @payment = @subscription.payments.create(
              amount: params[:data][:object][:amount],
              customer_id: @subscription.subscriber_id,
              customer_type: @subscription.subscriber_type,
              method_cc: true,
              method_type: params[:data][:object][:source][:brand],
              method_currency: params[:data][:object][:currency],
              merchant_response_status: params[:data][:object][:status],
              merchant_response_receiptcc: params[:data][:object][:id],
              merchant_response_card_last4: params[:data][:object][:source][:last4],
              payer_name: @subscription.subscriber_name,
              payer_email: @subscription.subscriber_email_primary,
              payer_address_street_1: params[:data][:object][:source][:address_line1],
              payer_address_street_2: params[:data][:object][:source][:address_line2],
              payer_address_city: params[:data][:object][:source][:address_city],
              payer_address_state: params[:data][:object][:source][:address_state],
              payer_address_country: params[:data][:object][:source][:address_country]
              )
            
            if @payment
              @subscription.renew!
              ::SubscriptionMailer.payment_succeeded(@subscription, @payment).deliver_now
            else
              render nothing: true, status: 500
            end
            
          end
        end
      end
      
      if params[:type] == 'charge.failed'
        @subscription = ::Subscription.valid.find_by(merchant_customer_id: customer_id)

        if @subscription
          ::SubscriptionMailer.payment_failed(@subscription, Payment.new(amount: params[:data][:object][:amount])).deliver_now
          
          @subscription.update_attributes active: false
        end
      end
    end
    
    if params[:type] == 'customer.subscription.trial_will_end'
      @subscription = ::Subscription.valid.find_by(merchant_customer_id: customer_id)
      @trial_start = Time.at(params[:data][:object][:trial_start])
      @trial_end = Time.at(params[:data][:object][:trial_end])
      
      if @subscription
        ::SubscriptionMailer.trial_will_end(@subscription, @trial_start, @trial_end).deliver_now
      end
    end
    
    render nothing: true, status: 200
  end
  
  private
  
  def verify_event
    @event = Stripe::Event.retrieve(params[:id]) rescue nil
    
    unless @event
      render nothing: true, status: 404
    else
    end
  end
end
