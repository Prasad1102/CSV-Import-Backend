class CreateComponies < ActiveRecord::Migration[8.0]
  def change
    create_table :componies do |t|
      t.string :name
      t.date :established_date
      t.string :ceo
      t.string :head_office
      t.string :website

      t.timestamps
    end
  end
end
