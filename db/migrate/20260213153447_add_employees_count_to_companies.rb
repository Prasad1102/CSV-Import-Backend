class AddEmployeesCountToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :componies, :employees_count, :integer, default: 0
  end
end
