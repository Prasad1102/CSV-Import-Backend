class ChangeColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :imports, :errors, :import_errors
  end
end
