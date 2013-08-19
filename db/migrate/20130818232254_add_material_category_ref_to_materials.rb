class AddMaterialCategoryRefToMaterials < ActiveRecord::Migration
  def change
    add_reference :materials, :material_category, index: true
  end
end
