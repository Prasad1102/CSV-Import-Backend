class ChangeColumnType < ActiveRecord::Migration[8.0]
  def change
    change_column :employees, :mobile, :string
  end
end
