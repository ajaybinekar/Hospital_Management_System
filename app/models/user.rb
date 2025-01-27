class User < ApplicationRecord
  has_one :doctor
  has_one :patient
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          ROLES = %w[ patient].freeze

  def admin?
    role == "admin"
  end

  def doctor?
    role == "doctor"
  end

  def patient?
    role == "patient"
  end
end
