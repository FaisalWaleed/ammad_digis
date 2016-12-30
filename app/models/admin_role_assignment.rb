class AdminRoleAssignment < ActiveRecord::Base
  belongs_to :admin_role
  belongs_to :admin
end
