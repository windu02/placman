class CreateMaterialCategories < ActiveRecord::Migration
  def change
    create_table :material_categories do |t|
      t.timestamps
    end
  end
end
