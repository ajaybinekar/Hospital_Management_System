class AddDurationToAvailabilities < ActiveRecord::Migration[8.0]
  def change
    add_column :availabilities, :duration, :integer
  end
end
