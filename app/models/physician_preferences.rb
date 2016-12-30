class PhysicianPreferences
  
  def initialize(_p)
    @physician = _p
    return self
  end
  
  def physician
    @physician
  end
  
  def notification_methods
    _methods = []
    
    _methods << :email if physician && physician.notify_via_email?
    _methods << :sms if physician && physician.notify_via_sms?
    
    _methods
  end
end
