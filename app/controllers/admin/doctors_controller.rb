class Admin::DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_param, only: [ :show, :edit ]

  def index
    @doctors = Doctor.paginate(page: params[:page], per_page: 4)
  end

  def new
    @doctor = Doctor.new
  end
  def show
  end

  def create
  @doctor = Doctor.new(doctor_params)
  @user = User.create!(email: @doctor.email, password: SecureRandom.hex(8), role: "doctor")
  @doctor.user_id = @user.id
  if @doctor.save
    if @user.persisted?
      UserMailer.send_doctor_credentials(@user).deliver_now
      redirect_to admin_doctors_path, notice: "Doctor and user created successfully."
    else
      @doctor.destroy
      render :new, alert: "User creation failed."
    end
  else
    render :new
  end
end

  def edit
  end

  def update
    @doctor = Doctor.find(params[:id])
    if @doctor.update(doctor_params)
      redirect_to admin_doctors_path, notice: "Doctor updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy
    redirect_to admin_doctors_path, notice: "Doctor deleted successfully."
  end

  def utilization_doctors_report
    @doctor = Doctor.all
    respond_to do |format|
      format.csv { send_data Doctor.to_csv, filename: "doctor_utilization_report-#{Date.today}.csv" }
    end
  end
  def download_all_doctors_record
  @doctors = Doctor.all
  pdf = Prawn::Document.new
  @doctors.each do |doctor|
  pdf.text "First Name: #{doctor.first_name}"
  pdf.text "Last Name: #{doctor.last_name}"
  pdf.text "Date of Birth: #{doctor.date_of_birth.strftime('%d/%m/%Y') if doctor.date_of_birth}"
  pdf.text "Contact Number: #{doctor.contact_number}"
  pdf.text "Email: #{doctor.email}"
  pdf.text "Gender: #{doctor.gender}"
  pdf.text "qualifications: #{doctor.qualifications}"
  pdf.text "experience: #{doctor.experience}"
  end
  send_data pdf.render, filename: "Doctors_records.pdf", type: "application/pdf", disposition: "attachment"
end

  private

  def doctor_params
    params.require(:doctor).permit(:first_name, :middle_name, :last_name, :photo, :date_of_birth, :contact_number, :email, :nationality, :gender, :qualifications, :experience, :department_id, :user_id)
  end
  def set_param
    @doctor = Doctor.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
