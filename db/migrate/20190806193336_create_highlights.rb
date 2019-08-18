class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.string :place
      t.string :notes
      t.integer :trip_id
    end
  end
end
