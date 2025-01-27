class MedicalRecord < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  has_one_attached :document

  validates :condition, :medication, presence: true
end
