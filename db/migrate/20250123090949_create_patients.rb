class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.text :address
      t.string :contact_number
      t.string :email
      t.string :gender
      t.string :blood_group
      t.string :photo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
