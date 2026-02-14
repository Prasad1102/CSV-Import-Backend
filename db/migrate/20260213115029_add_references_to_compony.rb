class AddReferencesToCompony < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :compony, null: false, foreign_key: { to_table: :componies }
  end
end
