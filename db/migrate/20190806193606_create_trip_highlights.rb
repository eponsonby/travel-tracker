class CreateTripHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_highlights do |t|
      t.integer :trip_id
      t.integer :highlight_id
    end
  end
end
