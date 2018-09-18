class AddColumnToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :subtitle, :text
  end
end
