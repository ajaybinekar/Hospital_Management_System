class Patient < ApplicationRecord
  belongs_to :user
  has_many :admissions

  has_many :appointments, dependent: :destroy
  has_many :doctors, through: :appointments
  has_many :medical_records, dependent: :destroy

  validates :first_name, :last_name, :date_of_birth, :contact_number, :email, :gender, :blood_group, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } # Validate email format
end
