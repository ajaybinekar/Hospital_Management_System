class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_doctor!

  def index
    @patients = current_user.doctor.patients
  end

  def show
  @patient = current_user.doctor.patients.find_by(id: params[:id])

  if @patient.nil?
    redirect_to doctors_path, alert: "Patient not found or you do not have access to this patient."
    return
  end
  authorize @patient

  @medical_records = @patient.medical_records
end

  def add_medical_record
    @patient = Patient.find(params[:patient_id])
    authorize @patient
    @medical_record = @patient.medical_records.build(medical_record_params.merge(doctor: current_user.doctor))

    if @medical_record.save
      redirect_to doctor_path(@patient), notice: "Medical record added successfully."
    else
      render :new
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
