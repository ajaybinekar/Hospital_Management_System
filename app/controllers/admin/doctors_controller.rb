class Admin::DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @doctors = Doctor.all
  end

  def new
    @doctor = Doctor.new
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
    @doctor = Doctor.find(params[:id])
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

  private

  def doctor_params
    params.require(:doctor).permit(:first_name, :middle_name, :last_name, :photo, :date_of_birth, :contact_number, :email, :nationality, :gender, :qualifications, :experience, :department_id, :user_id)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
