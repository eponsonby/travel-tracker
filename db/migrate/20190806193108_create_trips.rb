class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :trip_title
      t.string :country
      t.string :city
      t.string :year
      t.string :category
      t.integer :user_id
    end
  end
end
