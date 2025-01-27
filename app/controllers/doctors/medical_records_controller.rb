class Doctors::MedicalRecordsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_doctor!

    def new
      @patient = Patient.find(params[:patient_id])
      @medical_record = @patient.medical_records.build
    end

    def create
     @patient = Patient.find_by(id: params[:patient_id]) # Use find_by to avoid exceptions

     if @patient.nil?
      redirect_to doctors_path, alert: "Patient not found." and return
     end

     @medical_record = @patient.medical_records.build(medical_record_params.merge(doctor: current_user.doctor))

     if @medical_record.save
      redirect_to doctor_path(current_user.doctor), notice: "Medical record added successfully."
     else
      render :new
     end
   end
  def download
      @medical_record = MedicalRecord.find(params[:id])
      if @medical_record.patient.doctors.include?(current_user.doctor)
        if @medical_record.document.attached?
          send_data @medical_record.document.download,
                    filename: @medical_record.document.filename.to_s,
                    type: @medical_record.document.content_type,
                    disposition: "attachment"
        else
          redirect_to doctor_path(current_user.doctor), alert: "No document attached to this medical record."
        end
      else
        redirect_to doctor_path(current_user.doctor), alert: "Access denied to this medical record."
      end
    end

    private

    def authorize_doctor!
      redirect_to root_path, alert: "Access denied." unless current_user.doctor?
    end

    def medical_record_params
      params.require(:medical_record).permit(:condition, :medication, :document)
    end
end
