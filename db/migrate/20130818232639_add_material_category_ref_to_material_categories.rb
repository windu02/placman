class AddMaterialCategoryRefToMaterialCategories < ActiveRecord::Migration
  def change
    add_reference :material_categories, :material_category, index: true
  end
end
