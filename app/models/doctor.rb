class Doctor < ApplicationRecord
  belongs_to :department
  belongs_to :user
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :patients, through: :appointments

  validates :first_name, :last_name, :email, :gender, :qualifications, :experience, presence: true

  def self.to_csv
    attributes = %w[id first_name qualifications department_id contact_number created_at updated_at]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |doctor|
        csv << attributes.map { |attr| doctor.send(attr) }
      end
    end
  end
end
