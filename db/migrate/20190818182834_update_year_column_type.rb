class UpdateYearColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :trips, :year, 'integer USING CAST(year AS integer)'
  end
end
