class Physician::TestResultsController < Physician::BaseController
  layout proc{ |c| c.request.xhr? ? false : ([:show].include?(c.action_name.to_sym) ? "physician/diagnostics" : "physician/dashboard") }
  
  before_action :load_patient
  
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @status = params[:status]
    @term = params[:term]
    @start_date = params[:start_date].to_date rescue nil
    @end_date = params[:end_date].to_date rescue nil
    
    if @status == 'archived'
      @test_results = current_physician.archived_test_results
    else
      @test_results = current_physician.unarchived_test_results
    end
    
    @test_results = @test_results.with_attachment.order(created_at: :desc)
    
    if @status == 'reviewed'
      @test_results = @test_results.reviewed
    else
      @test_results = @test_results.unreviewed
    end
    
    if @patient.present?
      @test_results = @test_results.where(patient: @patient)
    end
    
    if @term.present?
      @test_results = @test_results.joins('LEFT OUTER JOIN patients ON diagnostics.patient_id = patients.id')
      @test_results = @test_results.joins('LEFT OUTER JOIN laboratories ON diagnostics.laboratory_id = laboratories.id')
      
      @test_results = @test_results.where(
        'diagnostics.identifier = ? OR patients.firstname ILIKE ? OR patients.lastname ILIKE ? OR laboratories.name ILIKE ?', "#{@term}", "#{@term}%", "#{@term}%", "#{@term}%"
      )
    end
    
    if @start_date
      @test_results = @test_results.where('diagnostics.updated_at >= ?', @start_date)
    end
    
    if @end_date
      @test_results = @test_results.where('diagnostic.updated_at <= ?', @end_date)
    end
    
    @test_results = @test_results.page(@page).per(@per_page)
  end

  def show
    @test_result = current_physician.diagnostics.find(params[:id])
    @tags = TestTag.with_diagnostic(@test_result)
    @profiles = @test_result.profiled_testings.group_by(&:test_profile)
    #     @test_result.mark_as_reviewed! if @test_result
  end
  
  def archive
    @test_result = current_physician.test_results.find(params[:id])
    
    if @test_result
      if @test_result.archive_for_physician!
        flash[:notice] = "Test Result archived!"
      else
        flash[:error] = "Failed archiving Test Result"
      end      
    else
      flash[:error] = "Test Result not found!"
    end
    
    redirect_to physician_test_results_path
  end
  
  def review
    @test_result = current_physician.unarchived_test_results.find(params[:id])
    
    if @test_result
      if @test_result.mark_as_reviewed!
        flash[:notice] = "Test Result has been reviewed!"
        redirect_to physician_patient_test_results_path(@test_result.patient)
      else
        flash[:error] = "Failed marking Test Result as 'reviewed'"
        redirect_to physician_patient_test_result_path(@test_result.patient, @test_result)
      end      
    else
      flash[:error] = "Test Result not found!"
      redirect_to physician_test_results_path
    end
  end
  
  private
  
  def load_patient
    @patient = current_physician.patients.find(params[:patient_id]) rescue nil
  end
end
