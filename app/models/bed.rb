class Bed < ApplicationRecord
  belongs_to :room

  validates :number, presence: true, uniqueness: { scope: :room_id }
end
