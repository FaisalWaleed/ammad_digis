class Admin < ActiveRecord::Base
  acts_as_authentic

  has_attached_file :avatar,
    :styles => { :large => "300x300>", :medium => "240x240>", :small => "128x128>", :thumb => "64x64>", :tiny => "32x32>" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename"
  
  has_many :admin_role_assignments
  has_many :roles, :through => :admin_role_assignments
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
  scope :superadmins, -> { where("admins.superadmin = ?", true) }
  
  def role_symbols
    if self.superadmin?
      [:superadmin]
    else
      roles.map do |role|
        role.title.delete(' ').underscore.to_sym
      end
    end
  end
end
