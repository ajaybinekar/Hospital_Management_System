class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validates :slot, :status, presence: true
  validate :slot_availability

  private

  def slot_availability
    if Appointment.where(doctor_id: doctor_id, slot: slot).exists?
      errors.add(:slot, "is already booked for this doctor.")
    end
  end
end
