class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.integer :status, default: 0
      t.integer :failed_count
      t.integer :total_count
      t.integer :process_count

      t.timestamps
    end
  end
end
