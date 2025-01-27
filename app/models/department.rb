class Department < ApplicationRecord
  has_many :doctors, dependent: :destroy
  has_many :rooms, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
