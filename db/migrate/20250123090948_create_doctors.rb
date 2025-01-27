class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :photo
      t.date :date_of_birth
      t.string :contact_number
      t.string :email
      t.string :nationality
      t.string :gender
      t.string :qualifications
      t.string :experience
      t.references :department, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
