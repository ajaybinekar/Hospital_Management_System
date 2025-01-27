class CreateMedicalRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_records do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.text :condition
      t.text :medication
      t.string :document

      t.timestamps
    end
  end
end
