class AppointmentPolicy < ApplicationPolicy
  def index?
    user.doctor? || user.patient?
  end

  def show?
    (user.doctor? && record.doctor_id == user.doctor.id) ||
    (user.patient? && record.patient_id == user.patient.id)
  end

  def create?
    user.patient?
  end

  def update?
    user.doctor? && record.doctor_id == user.doctor.id
  end

  def destroy?
    false # Appointments cannot be deleted
  end

  class Scope < Scope
    def resolve
      if user.doctor?
        scope.where(doctor_id: user.doctor.id)
      elsif user.patient?
        scope.where(patient_id: user.patient.id)
      else
        scope.none
      end
    end
  end
end
