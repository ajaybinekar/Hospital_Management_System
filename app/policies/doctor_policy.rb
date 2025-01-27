class DoctorPolicy < ApplicationPolicy
  def index?
    user.doctor?
  end

  def show?
    user.doctor? && record.doctor_id == user.doctor.id
  end

  def create?
    user.doctor?
  end

  def update?
    user.doctor? && record.doctor_id == user.doctor.id
  end

  def destroy?
    false # Doctors cannot delete records
  end

  class Scope < Scope
    def resolve
      if user.doctor?
        scope.where(doctor_id: user.doctor.id)
      else
        scope.none
      end
    end
  end
end
