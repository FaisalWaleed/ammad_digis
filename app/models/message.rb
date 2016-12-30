class Message < ActiveRecord::Base
  belongs_to :asset, :polymorphic => true
  belongs_to :sender, :polymorphic => true
  
  attr_accessor :mark_as_resolved
  
  scope :unread, -> { where('messages.read != ?', true) }
  scope :read, -> { where('messages.read = ?', true) }
  
  before_validation do
    if mark_as_resolved?
      write_attribute :require_response, false
    end
    true
  end
  
  after_create do
    if asset.respond_to?(:commentable?)
      asset.update_attribute :commentable, !self.mark_as_resolved?
    end
  end
  
  def mark_as_read!
    update_attribute :read, true
  end
  
  def mark_as_resolved?
    self.mark_as_resolved == '1'
  end
end
