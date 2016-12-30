class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  
  def index
    @subscriptions = Subscription.order(created_at: :desc)
    
    if @term
      @subscriptions = @subscriptions.joins(:subscriber, :plan).where('UPPER(members.firstname) LIKE ? OR UPPER(members.lastname) LIKE ? OR UPPER(test_types.name) LIKE ? OR UPPER(plans.name) LIKE ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%")
    end
    
    @subscriptions = @subscriptions.page(@page).per(@per_page)
  end

  def show
  end

  def edit
  end

  def update
    if @subscription
      respond_to do |format|
        if @subscription.update_attributes(subscription_params)
          format.html { redirect_to [:admin, @subscription], notice: 'Subscription was successfully updated.' }
          format.json { render :show, status: :ok, location: [:admin, @subscription] }
        else
          format.html { render :edit }
          format.json { render json: @subscription.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to admin_subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
  
  def subscription_params
    params.require(:subscription).permit(
      :subscription_period_amount,
      :subscription_period_unit,
      :grace_period_amount,
      :grace_period_unit,
      :trial_period_amount,
      :trial_period_unit,
      :subscriber_limit,
      :organization_limit,
      :renew_notify,
      :auto_renew
      )
  end
end
