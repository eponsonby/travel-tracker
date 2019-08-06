class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.string :category
      t.string :place
      t.integer :trip_id
    end
  end
end
