class Admin::AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @availabilities = Availability.all.includes(:doctor)
  end

  def new
    @availability = Availability.new
    @doctors = Doctor.all
  end

  def create
    @availability = Availability.new(availability_params)

    if @availability.start_time >= @availability.end_time
      flash.now[:alert] = "End time must be after start time."
      @doctors = Doctor.all
      render :new and return
    end

    if overlapping_availability?(@availability)
      flash.now[:alert] = "This availability overlaps with an existing slot for this doctor."
      @doctors = Doctor.all
      render :new and return
    end

    if @availability.save
      redirect_to admin_availabilities_path, notice: "Availability created successfully."
    else
      @doctors = Doctor.all
      render :new
    end
  end

  def edit
    @availability = Availability.find(params[:id])
    @doctors = Doctor.all
  end

  def update
    @availability = Availability.find(params[:id])
    # Validate that the end time is after the start time
    if availability_params[:start_time] >= availability_params[:end_time]
      flash.now[:alert] = "End time must be after start time."
      @doctors = Doctor.all
      render :edit and return
    end

    if overlapping_availability?(@availability)
      flash.now[:alert] = "This availability overlaps with an existing slot for this doctor."
      @doctors = Doctor.all
      render :edit and return
    end

    if @availability.update(availability_params)
      redirect_to admin_availabilities_path, notice: "Availability updated successfully."
    else
      @doctors = Doctor.all
      render :edit
    end
  end

  def destroy
    @availability = Availability.find(params[:id])
    @availability.destroy
    redirect_to admin_availabilities_path, notice: "Availability deleted successfully."
  end

  private

  def availability_params
    params.require(:availability).permit(:doctor_id, :start_time, :end_time, :status, :duration)
  end


  def overlapping_availability?(new_availability)
    Availability.where(doctor_id: new_availability.doctor_id)
                .where.not(id: new_availability.id)
                .where("start_time < ? AND end_time > ?", new_availability.end_time, new_availability.start_time)
                .exists?
  end
  def availability_params
    params.require(:availability).permit(:doctor_id, :start_time, :end_time, :status, :duration)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
