class AdminRole < ActiveRecord::Base
  has_many :admin_role_assignments
  has_many :admins, :through => :admin_role_assignments
end
