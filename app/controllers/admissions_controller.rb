class AdmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [ :new, :create, :discharge ]

  def new
    @rooms = Room.all.select(&:available?)
    @admission = Admission.new
  end

  def create
    @room = Room.find(params[:admission][:room_id])

    if @room.available?
      @admission = Admission.new(admission_params)
      @admission.patient = @patient
      @admission.admission_date = Time.current

      if @admission.save
        redirect_to @patient, notice: "Patient admitted successfully."
      else
        @rooms = Room.all.select(&:available?)
        render :new
      end
    else
      flash[:alert] = "Room is not available."
      redirect_to new_patient_admission_path(@patient)
    end
  end

  def discharge
    if @admission.update(discharge_date: Time.current) # Set the discharge date
      redirect_to patients_path, notice: "Patient was successfully discharged."
    else
      redirect_to patients_path, alert: "Failed to discharge the patient."
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def admission_params
    params.require(:admission).permit(:room_id, :admission_date, :discharge_date)
  end
end
