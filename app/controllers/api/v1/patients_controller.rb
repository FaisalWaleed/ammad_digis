
module Api
  
  module V1
    
    class PatientsController < Api::ApiController
      
      def search
        term = params[:term]
        
        matches = current_physician.patients.where("(patients.firstname || ' ' || patients.lastname) ILIKE ?", "%#{term}%")
        
        
        render json: matches.to_json(
          :only => [ :id, :address_street_1, :address_street_2, :email_primary, :phone_primary ],
          :methods => [ :label, :name, :gender_abbrev, :age ]
        )
        
      end
      
      def send_verification_code
        phone = patient_params[:phone_primary]
        email = patient_params[:email_primary]
        
        patient = current_physician.patients.find(params[:patient_id]) rescue current_physician.patients.build(patient_params)

        if email.present?
          email_code = patient.generate_pin
          patient.email_verification_code = email_code
          PatientMailer.verify_email(patient, email, email_code).deliver_now
        end
        
        if phone.present?
          phone_code = patient.generate_pin
          patient.phone_verification_code = phone_code
          message = "Your verification code is: #{phone_code}"
          
          puts "\n\n ****** #{message} ******\n\n"
          
          c = Twilio::REST::Client.new
          
          from = ENV["TWILIO_NUMBER"]
          to = "+1" + phone
          
          c.messages.create from: from, to: to, body: message
        end
        
        unless patient.new_record?
          patient.save if email_code.present? || phone_code.present?
        end
        
        render json: { message: "", email: email, phone: phone, email_code: email_code, phone_code: phone_code }
      end
      
      def verify
        attrs = {
          email_verification_code: params[:patient_email_code],
          phone_verification_code: params[:patient_phone_code]
          }.delete_if{ |k,v| v.strip.blank? }
        
        patient = current_physician.patients.find_by(attrs)
        
        patient_params = params.require(:patient).permit(
          :firstname,
          :lastname,
          :middlename
        )

        if patient
          if attrs[:phone_verification_code].present? && patient.phone_verification_code == attrs[:phone_verification_code]
            patient_params = patient_params.merge(phone_verified: true, phone_primary: params[:patient][:phone_primary])
          end

          if attrs[:email_verification_code].present? && patient.email_verification_code == attrs[:email_verification_code]
            patient_params = patient_params.merge(email_verified: true, email_primary: params[:patient][:email_primary])
          end
          
          if patient.update_attributes(patient_params)
            render json: { message: "Patient updated successfully", patient: patient.as_json }
          else
            render json: { message: "Updating patient failed", patient: patient.as_json }
          end
        else
          render json: { message: "Patient not found", params: params }
        end
      end
      
      private
      
      def patient_params
        params.require(:patient).permit(
          :firstname,
          :lastname,
          :middlename,
          :phone_primary,
          :email_primary
        )
      end
    end
    
  end
  
end
