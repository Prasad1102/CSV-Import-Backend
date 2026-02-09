class ChangeDefaultForImportErrors < ActiveRecord::Migration[8.0]
  def change
    change_column_default :imports, :import_errors, {}
  end
end
