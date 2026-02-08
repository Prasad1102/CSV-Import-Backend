class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.integer :mobile
      t.integer :role
      t.date :joining_date

      t.timestamps
    end
  end
end
