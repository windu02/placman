class AddedNameToMaterialCategories < ActiveRecord::Migration
  def change
    add_column :material_categories, :name, :string
  end
end
