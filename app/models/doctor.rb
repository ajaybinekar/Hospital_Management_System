class Doctor < ApplicationRecord
  belongs_to :department
  belongs_to :user
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :patients, through: :appointments

  validates :first_name, :last_name, :email, :gender, :qualifications, :experience, presence: true
end
