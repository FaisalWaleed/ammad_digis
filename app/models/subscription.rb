class Subscription < ActiveRecord::Base
  belongs_to :subscriber, :polymorphic => true
  belongs_to :plan
  belongs_to :coupon
  
  has_many :payments, :inverse_of => :subscription
  
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => false
  
  scope :expired, -> { where('subscriptions.expire_at <= ?', Time.now.to_date) }
  scope :valid, -> { where("(subscriptions.active = ? AND current_date <= (subscriptions.expire_at + CONCAT(COALESCE(subscriptions.grace_period_amount, 0), ' ', COALESCE(subscriptions.grace_period_unit, 'days'))::INTERVAL)) OR expire_at IS NULL", true) }
  
  scope :active, -> { where('subscriptions.active = ?', true) }
  scope :inactive, -> { where('subscriptions.active != ?', true) }
  
  validates :expire_at, :presence => true
  validates :price, :presence => true
  
  delegate :name, :to => :subscriber, :prefix => true, :allow_nil => true
  delegate :email_primary, :to => :subscriber, :prefix => true, :allow_nil => true
  
  after_initialize do
    update_from_plan if new_record?
  end
  
  after_destroy :cancel!
  
  after_create do
    stripe_customer = nil
    
    stripe_customer = Stripe::Customer.retrieve(subscriber.customer_id)
    
    if stripe_customer.present?
      if plan.publish_id.present?
        stripe_subscription = Stripe::Subscription.create(
          customer: stripe_customer.id,
          plan: plan.publish_id
          )
        
        if stripe_subscription
          update_attributes merchant_id: stripe_subscription.id, merchant_customer_id: stripe_customer.id
        end
      end
    end
  end
  
  def identifier
    "#{ id }"
  end
  
  def expired?
    expire_at && expire_at < Time.now.to_date
  end
  
  def renewable?
    expired? || new_record? || merchant_id.blank?
  end
  
  def activate!
    update_attribute :active, true
  end
  
  def activate
    if total_payments >= self.price
      activate!
    end
  end
  
  def total_payments
    payments.inject(0){ |sum, p| p.amount.to_f + sum }
  end
  
  def subscription_period
    "#{ subscription_period_amount } #{ subscription_period_unit.pluralize(subscription_period_amount) }"
  end
  
  def trial_period
    "#{ trial_period_amount } #{ trial_period_unit.pluralize(trial_period_amount) }"
  end
  
  def grace_period
    "#{ plan.grace_period_amount } #{ plan.grace_period_unit.pluralize(plan.grace_period_amount) }"
  end
  
  def plan_subscription_period
    "#{ plan.subscription_period_amount } #{ plan.subscription_period_unit.pluralize(plan.subscription_period_amount) }"
  end
  
  def plan_trial_period
    "#{ plan.trial_period_amount } #{ plan.trial_period_unit.pluralize(plan.trial_period_amount) }"
  end
  
  def plan_grace_period
    "#{ grace_period_amount } #{ grace_period_unit.pluralize(grace_period_amount) }"
  end
  
  def deactivate!
    update_attribute :active, false
  end
  
  def due_for_renewal?
    renewable?
  end
  
  def cancel!
    if merchant_id.present?
      subscription = Stripe::Subscription.retrieve(merchant_id)
      
      if subscription.present?
        subscription.delete(at_period_end: true)
        SubscriptionMailer.cancelled(self).deliver_now
      end
    end
    
#     update_attribute :active, false
    update_attribute :merchant_id, nil unless frozen?
  end
  
  def renew!
    update_from_plan
    save
  end
  
  private
  
  def update_from_plan
    if plan
      write_attribute :subscription_period_amount, plan.subscription_period_amount
      write_attribute :subscription_period_unit, plan.subscription_period_unit
      write_attribute :grace_period_amount, plan.grace_period_amount
      write_attribute :grace_period_unit, plan.grace_period_unit
      write_attribute :trial_period_amount, plan.trial_period_amount
      write_attribute :trial_period_unit, plan.trial_period_unit
      write_attribute :renew_notify, plan.renew_notify
      write_attribute :auto_renew, plan.auto_renew
      write_attribute :price, plan.price
      write_attribute :currency, plan.currency
      write_attribute :subscriber_limit, plan.subscriber_limit
      write_attribute :organization_limit, plan.organization_limit
      write_attribute :plan_publish_id, plan.publish_id
      
      write_attribute :expire_at, eval("#{plan.subscription_period_amount}.#{plan.subscription_period_unit}.from_now + #{plan.trial_period_amount || 0}.#{plan.trial_period_unit || 'days'}")
    end
  end
end
