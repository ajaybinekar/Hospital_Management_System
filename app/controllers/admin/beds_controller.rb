class Admin::BedsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_bed, only: %i[show edit update destroy]

  def index
    @beds = Bed.all.includes(:room)
  end

  def show
  end

  def new
    @bed = Bed.new
    @rooms = Room.all
  end

  def create
    @bed = Bed.new(bed_params)
    if @bed.save
      redirect_to admin_beds_path, notice: "Bed was successfully created."
    else
      @rooms = Room.all
      render :new
    end
  end

  def edit
    @rooms = Room.all
  end

  def update
    if @bed.update(bed_params)
      redirect_to admin_beds_path, notice: "Bed was successfully updated."
    else
      @rooms = Room.all
      render :edit
    end
  end

  def destroy
    @bed.destroy
    redirect_to admin_beds_path, notice: "Bed was successfully destroyed."
  end

  private

  def set_bed
    @bed = Bed.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end

  def bed_params
    params.require(:bed).permit(:number, :room_id)
  end
end
