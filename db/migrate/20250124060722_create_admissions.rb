class CreateAdmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :admissions do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :admission_date
      t.datetime :discharge_date

      t.timestamps
    end
  end
end
