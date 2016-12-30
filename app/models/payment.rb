class Payment < ActiveRecord::Base
  attr_accessor :cc_token
  
  belongs_to :subscription
  
  has_one :plan, :through => :subscription
  
  belongs_to :customer, :polymorphic => true
  
  validates :amount, :presence => true
#   validates :payer_name, :presence => true
#   validates :payer_address_street_1, :presence => true
#   validates :payer_address_city, :presence => true
#   validates :payer_address_country, :presence => true
  validates :customer, :presence => true
  
  scope :recent, -> { where('payments.created_at > ?', 60.seconds.ago) }
  
  validate do
    if self.merchant_response_receiptcc.blank?
      self.errors.add :base, 'Credit card payment failed'
    end
  end
  
  before_validation do
    # process if self.merchant_response_status.blank?
  end
  
  before_validation do
    if payer_name.blank?
      write_attribute :payer_name, customer.name
    end
  end
  
  after_create do
    subscription.activate
  end
  
  def process
    stripe_customer = Stripe::Customer.create email: customer.email_primary,
                                       card: cc_token

    if(charge = Stripe::Charge.create(customer: stripe_customer.id,
                          amount: (self.amount.to_f * 100).to_i,
                          description: subscription.plan.name,
                          currency: (subscription.currency || 'jmd')))

      write_attribute :merchant_response_receiptcc, charge.id
      write_attribute :merchant_response_status, charge.status
      write_attribute :method_cc, true
      write_attribute :method_currency, charge.currency
      write_attribute :paid_at, Time.at(charge.created)
      
      customer.update_attribute(:customer_id, stripe_customer.id)
    end
    
  end
end
