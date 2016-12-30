module CardsController
  
  def self.included(base)
    base.class_eval do
      skip_before_filter :require_active_subscription
      
      before_action :load_current_customer
      before_action :load_stripe_customer
      before_action :load_cards
      before_action :load_active_card, except: [ :index, :new, :create ]
      
      helper_method :customer_card_path, :customer_cards_path, :customer_subscriptions_path, :edit_customer_card_path
      
      define_method :customer_cards_path do
        send("#{@customer.class.name.underscore.parameterize}_cards_path")
      end
      
      define_method :customer_card_path do |id|
        send("#{@customer.class.name.underscore.parameterize}_card_path", id)
      end
      
      define_method :edit_customer_card_path do |id|
        send("edit_#{@customer.class.name.underscore.parameterize}_card_path", id)
      end
      
      define_method :customer_subscriptions_path do
        send("#{@customer.class.name.underscore.parameterize}_subscriptions_path")
      end
    end
  end
  
  def index
  end
  
  def new
  end
  
  def create
    if @stripe_customer.present?
      source = {
        object: 'card',
        name: card_params[:name].presence,
        number: card_params[:number].presence,
        cvc: card_params[:cvc].presence,
        exp_month: card_params[:exp_month].presence,
        exp_year: card_params[:exp_year].presence,
        address_line1: card_params[:address_line1].presence,
        address_line2: card_params[:address_line2].presence,
        address_city: card_params[:address_city].presence,
        address_state: card_params[:address_state].presence,
        address_zip: card_params[:address_zip].presence,
        address_country: card_params[:address_country].presence
      }
      
      begin
        @stripe_customer.sources.create( source: source )
        
        flash[:success] = "Added your card successfully"
        redirect_to customer_subscriptions_path
      rescue Exception => e
        flash[:error] = "Failed: #{e}"
#         render action: :new # NOTE: cant do this here since @card isnt a valid  AR object, it will throw an error in the view
        redirect_to customer_subscriptions_path # NOTE: DO this instead for now.
      end
      
    end
  end
  
  def edit
  end
  
  def update
    if @card
      @card.name = card_params[:name].presence
      @card.exp_month = card_params[:exp_month].presence
      @card.exp_year = card_params[:exp_year].presence
      @card.address_line1 = card_params[:address_line1].presence
      @card.address_line2 = card_params[:address_line2].presence
      @card.address_city = card_params[:address_city].presence
      @card.address_state = card_params[:address_state].presence
      @card.address_zip = card_params[:address_zip].presence
      @card.address_country = card_params[:address_country].presence
      
      begin
        @card.save
        flash[:success] = "Card information updated successfully"
        redirect_to customer_subscriptions_path
      rescue
        flash[:error] = "Failed: #{e}"
        render action: :edit
      end
    else
      flash[:error] = "It appears you do not have an active card."
      redirect_to customer_subscriptions_path
    end
  end
  
  def show
    redirect_to customer_subscriptions_path
  end
  
  def destroy
    begin
      @card.delete
      flash[:success] = "Card removed successfully"
    rescue Exception => e
      flash[:error] = "Failed: #{e}"
    end
    
    redirect_to customer_subscriptions_path
  end
  
  def default
    if @stripe_customer
      unless params[:card_id].blank?
        @stripe_customer.default_source = params[:card_id]

        begin
          @stripe_customer.save
          flash[:success] = "Default card has been set"
        rescue Exception => e
          flash[:success] = "Failed: #{e}"
        end
      else
        # TODO
      end
    else
      # TODO
    end
    
    redirect_to customer_cards_path
  end
  
  private
  
  def load_stripe_customer
    @stripe_customer = Stripe::Customer.retrieve(@customer.customer_id)
  end
  
  def load_cards
    @cards = @stripe_customer.sources.data rescue nil
  end
  
  def load_active_card
    unless @card = @cards.first
      flash[:error] = "You do not have an active credit card on your account."
      redirect_to customer_subscriptions_path
    end
  end
  
  def card_params
    params.require(:card).permit(
      :name,
      :number,
      :cvc,
      :exp_month,
      :exp_year,
      :address_city,
      :address_country,
      :address_line1,
      :address_line2,
      :address_state,
      :address_zip
      )
  end
end
