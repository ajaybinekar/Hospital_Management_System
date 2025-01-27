
class Room < ApplicationRecord
  belongs_to :department
  has_many :beds, dependent: :destroy
  has_many :admissions, dependent: :destroy # Add this association to track admissions

  validates :number, presence: true, uniqueness: { scope: :department_id }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 } # Ensure capacity is validated
  before_validation :set_default_capacity

  def self.to_csv
    attributes = %w[id number department_id created_at updated_at]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |room|
        csv << attributes.map { |attr| room.send(attr) }
      end
    end
  end

  def available?
    return false if capacity.nil?
    admissions.count < capacity
  end
  def set_default_capacity
    self.capacity ||= 30
  end
end
