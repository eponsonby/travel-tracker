class DropColumnFromHighlights < ActiveRecord::Migration[5.2]
  def change
    remove_column :highlights, :highlight_category
  end
end
