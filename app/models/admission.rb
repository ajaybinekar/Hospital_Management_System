class Admission < ApplicationRecord
  belongs_to :patient
  belongs_to :room

  validates :admission_date, presence: true
  validates :patient_id, presence: true
  validates :room_id, presence: true

  def active?
    admission_date.present? && (discharge_date.nil? || discharge_date > Time.current)
  end
  def discharged?
    discharge_date.present?
  end
end
