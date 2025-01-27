class PatientPolicy < ApplicationPolicy
  def index?
    user.patient?
  end

  def show?
    user.patient? && record.user_id == user.id
  end

  def create?
    true # Open registration
  end

  def update?
    user.patient? && record.user_id == user.id
  end

  def destroy?
    false # Patients cannot delete their accounts
  end

  class Scope < Scope
    def resolve
      if user.patient?
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end
