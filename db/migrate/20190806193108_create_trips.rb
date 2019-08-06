class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :country
      t.string :city
      t.string :date_visited
      t.string :type
      t.integer :user_id
    end
  end
end
