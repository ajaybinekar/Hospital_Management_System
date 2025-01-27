class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
  if current_user.patient?
    @appointments = current_user.patient.appointments.includes(:doctor).map do |appointment|
      appointment.slot = DateTime.parse(appointment.slot) if appointment.slot.is_a?(String)
      appointment
    end
  elsif current_user.doctor?
    @appointments = current_user.doctor.appointments.includes(:patient).map do |appointment|
      appointment.slot = DateTime.parse(appointment.slot) if appointment.slot.is_a?(String)
      appointment
    end
  else
    redirect_to root_path, alert: "Access denied."
  end
end


  def new
    @appointment = Appointment.new
    @doctor = Doctor.find(params[:doctor_id])
    @availabilities = Availability.where(doctor_id: @doctor.id, status: "available")
  end

  def create
    @appointment = Appointment.new(appointment_params.merge(patient: current_user.patient, status: "booked"))
    if @appointment.save
      redirect_to patient_appointments_path(current_user.patient), notice: "Appointment booked successfully."
    else
      @doctors = Doctor.all # Re-fetch doctors in case of error
      render :new
    end
  end

  def cancel
  @appointment = Appointment.find(params[:id])
  if @appointment.status == "booked"
    @appointment.update(status: "available")
    redirect_to patient_appointments_path(current_user.patient), notice: "Appointment canceled successfully."
  else
    redirect_to patient_appointments_path(current_user.patient), alert: "Cannot cancel this appointment."
  end
end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :slot, :status)
  end
end
