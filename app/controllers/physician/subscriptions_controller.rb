require 'csv'

class Physician::SubscriptionsController < Physician::BaseController
  before_action :load_subscription, :except => [ :index, :new, :create ]
  
  before_action :load_active_subscription, :only => [ :create ]
  
  before_action :load_plan, :only => [ :new ]
  skip_before_action :require_active_subscription
  skip_before_action :require_profile
  
  def index
    @active_subscription = current_physician.active_subscription
    @payments = current_physician.payments
    @subscriptions = current_physician.subscriptions.order(created_at: :desc).limit(12)
    
    @active_card = Stripe::Customer.retrieve(current_physician.customer_id).sources.data.first rescue nil
    
    respond_to do |format|
      format.html do
        @subscriptions = @subscriptions.limit(12)
      end
      
      format.csv do
        content = CSV.generate do |csv|
          csv << ["Plan", "Active", "Subscription Period", "Trial Period", "Grace Period", "Payments", "Expire"]
          
          for s in @subscriptions
            csv << [
              s.plan.name,
              s.active?? 'Yes' : 'No',
              s.subscription_period,
              s.trial_period,
              s.grace_period,
              s.total_payments,
              s.expire_at.to_date.strftime('%d/%m/%Y')
            ]
          end
        end
        
        send_data content, 
		  :type => 'text/csv; charset=iso-8859-1; header=present', 
          :disposition => "attachment; filename=digiscript_physician_subscriptions_#{ Time.now.strftime('%Y-%m-%d') }.csv" 
      end
    end
  end

  def new
    @subscription = Subscription.new(plan_id: (@plan.id rescue nil))
    @plans = Plan.all #Plan.published.available_to_physician
  end

  def create
    if @active_subscription.blank? || @active_subscription.renewable?
      
      @subscription = current_physician.subscriptions.build(subscription_params)
      @subscription.payments.first.amount = @subscription.plan.price # HACK
      
      if @subscription.save
        flash[:success] = "Subscription successful"
        redirect_to physician_root_url
      else
        flash[:error] = "Subscription attempt failed"
        render :action => :new
      end
    else
      flash[:error] = "Subscription is not renewable at this time."
      redirect_to physician_root_url
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.cancel!
    flash[:success] = "Subscription cancelled successfully"
    redirect_to physician_subscriptions_path
  end
  
  private
  
  def load_plan
    @plan = Plan.published.available_to_physician.find(params[:plan_id] || session[:subscribe_plan_id]) rescue Plan.published.available_to_physician.default.random.first
  end
  
  def load_subscription
    @subscription = Subscription.find(params[:subscription_id] || params[:id])
  end
  
  def load_active_subscription
    if current_physician.active_subscription
      @active_subscription = current_physician.active_subscription
    elsif current_physician.subscriptions.last
      @active_subscription = current_physician.subscriptions.last
    end
  end
  
  def subscription_params
    params.require(:subscription).permit :plan_id,
        :renew_notify,
        :auto_renew,
        :payments_attributes => [
          :cc_token,
          :method_type,
          :customer_type,
          :customer_id,
          :amount,
          :payer_name,
          :payer_email,
          :payer_address_street_1,
          :payer_address_street_2,
          :payer_address_city,
          :payer_address_state,
          :payer_address_country
          ]
  end
end
