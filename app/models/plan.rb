class Plan < ActiveRecord::Base
  has_many :subscriptions
  
  scope :available_to_physician, -> { where('plans.available_to_physician = ?', true) }
  scope :available_to_pharmacy, -> { where('plans.available_to_pharmacy = ?', true) }
  scope :available_to_patient, -> { where('plans.available_to_patient = ?', true) }
  scope :available_to_laboratory, -> { where('plans.available_to_technician = ?', true) }
  scope :published, -> { where('plans.published = ? AND plans.publish_id IS NOT NULL', true) }
  scope :default, -> { where('plans.default = ?', true) }
  scope :random, -> { order('RANDOM()') }
  
  # before_save do
  #   if self.published?
  #     unless stripe_plan.present?
  #       @stripe_plan = Stripe::Plan.create(
  #         :amount => (price.to_f * 100).to_i,
  #         :interval => self.subscription_period_unit.to_s.singularize,
  #         :interval_count => self.subscription_period_amount,
  #         :name => self.name,
  #         :currency => self.currency || 'usd',
  #         :id => self.identifier,
  #         :trial_period_days => self.trial_period_days
  #       )
  #     end
      
  #     if stripe_plan && stripe_plan.id
  #       write_attribute(:publish_id, stripe_plan.id)
  #     end
  #   else
  #     if stripe_plan.present?
  #       delete_from_stripe!
  #     end
  #   end
  # end
  
  after_destroy do
    delete_from_stripe!
  end
  
  def delete_from_stripe!
    if stripe_plan.present?
      stripe_plan.delete
      
      update_attribute :publish_id, nil unless frozen?
    end
  end
  
  def stripe_plan
    @stripe_plan ||= load_from_stripe
  end
  
  def load_from_stripe
    p_id = read_attribute(:publish_id)
    
    @stripe_plan = (Stripe::Plan.retrieve(p_id) rescue nil) unless p_id.blank?
  end
  
  def identifier
    users = []
    
    users << 'patient' if available_to_patient?
    users << 'physician' if available_to_physician?
    users << 'pharmacy' if available_to_pharmacy?
    users << 'technician' if available_to_technician?
    
    "#{ users.join('_') }_#{ self.name }".parameterize.underscore
  end
  
  def trial_period_days
    30 || ((self.trial_period_amount.send(self.trial_period_unit).seconds / 3600) / 24) rescue nil
  end
end
