class PatientsController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @patients = Patient.all
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def new
    @patient = Patient.new
  end

  def dashboard
    @patient = current_user.patient
    @doctors = Doctor.all.includes(:availabilities)  # Fetch all doctors with their availabilities
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.user_id = current_user.id
    if @patient.save
      redirect_to patient_dashboard_path(@patient), notice: "Registration successful. Please log in."
    else
      render :new
    end
  end
  def download_medical_record
  @patient = Patient.find(params[:id])
  pdf = Prawn::Document.new

  pdf.text "Medical Records for #{@patient.first_name} #{@patient.last_name}", size: 20, style: :bold
  pdf.move_down 20

  pdf.text "First Name: #{@patient.first_name}"
  pdf.text "Last Name: #{@patient.last_name}"
  pdf.text "Date of Birth: #{@patient.date_of_birth.strftime('%d/%m/%Y') if @patient.date_of_birth}"
  pdf.text "Contact Number: #{@patient.contact_number}"
  pdf.text "Email: #{@patient.email}"
  pdf.text "Gender: #{@patient.gender}"
  pdf.text "Blood Group: #{@patient.blood_group}"

  pdf.move_down 20
  pdf.text "Medical Records", size: 16, style: :bold

  @patient.medical_records.each do |record|
    pdf.text "Condition: #{record.condition}"
    pdf.text "Medication: #{record.medication}"
    pdf.move_down 10
  end

  send_data pdf.render, filename: "medical_records_#{@patient.id}.pdf", type: "application/pdf", disposition: "attachment"
end

  private

  def patient_params
    params.require(:patient).permit(:first_name, :middle_name, :last_name, :date_of_birth, :address, :contact_number, :email, :gender, :blood_group, :photo)
  end
end
