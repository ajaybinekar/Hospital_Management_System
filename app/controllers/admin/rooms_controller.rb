class Admin::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_room, only: %i[show edit update destroy]

  def index
    @rooms = Room.all
  end

  def utilization_report
    @rooms = Room.all
    respond_to do |format|
      format.csv { send_data Room.to_csv, filename: "room_utilization_report-#{Date.today}.csv" }
    end
  end
  def show
  end

  def new
    @room = Room.new(capacity: 30)
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to admin_rooms_path, notice: "Room was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to admin_rooms_path, notice: "Room was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to admin_rooms_path, notice: "Room was successfully destroyed."
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin? || current_user.doctor?
  end

  def room_params
    params.require(:room).permit(:number, :department_id, :capacity)
  end
end
