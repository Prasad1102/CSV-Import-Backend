class AddUniquenessToEmployeeEmail < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      DELETE FROM employees
      WHERE id NOT IN (
        SELECT MIN(id)
        FROM employees
        GROUP BY email
      );
    SQL
    add_index :employees, :email, unique: true
  end

  def down
    remove_index :employees, :email
  end
end
