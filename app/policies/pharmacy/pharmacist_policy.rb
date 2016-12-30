class Pharmacy::PharmacistPolicy < ApplicationPolicy
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
