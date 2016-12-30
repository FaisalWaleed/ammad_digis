class Patient::DiagnosticsController < Patient::BaseController
  before_action :require_auth
  before_action :set_diagnostic, :except => [ :index ]

  def index
  end
  
  def edit
    @tags = TestTag.with_diagnostic(@diagnostic)
    @profiles = @diagnostic.profiled_testings.group_by(&:test_profile)
  end
  
  def show
  end
  
  def update
    if @diagnostic.update_attributes(diagnostic_params)
      flash[:success] = "Diagnostic details updated successfully"
    else
      flash[:error] = "Diagnostic update failed"
    end
    
    redirect_to patient_diagnostic_path(@diagnostic)
  end
  
  private
  
  def set_diagnostic
    begin
      @diagnostic = current_patient.diagnostics.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "It seems you do not own the diagnostic you are attempting to access. Please recheck your diagnostic number and verification pin. Thank you."
      
      current_patient_session.destroy
      
      redirect_to patient_login_url
    end
  end
  
  def diagnostic_params
    params.require(:diagnostic).permit(
      :laboratory_id,
      :laboratory_name
    )
  end
end
