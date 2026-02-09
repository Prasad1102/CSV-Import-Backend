class AddValidationToEmployee < ActiveRecord::Migration[8.0]
  def change
    add_column :imports, :errors, :jsonb, default: []
  end
end
