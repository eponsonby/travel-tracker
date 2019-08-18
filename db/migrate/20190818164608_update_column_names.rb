class UpdateColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :trips, :year_visited, :year
  end
end
