class AddedDenominationAndUnitToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :denomination, :string
    add_column :materials, :unit, :string, :default => "Unit"
  end
end
