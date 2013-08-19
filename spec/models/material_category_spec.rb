# == Schema Information
#
# Table name: material_categories
#
#  id                   :integer          not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  material_category_id :integer
#

require 'spec_helper'

describe MaterialCategory do
  before(:each) do
    @attr = {
      :name => "Placo"
    }
  end

  it "should create a new instance given a valid attribute" do
    MaterialCategory.create!(@attr)
  end

  it "should require a name" do
    no_name_material_category = MaterialCategory.new(@attr.merge(:name => ""))
    no_name_material_category.should_not be_valid
  end

  it "should have 'addMaterial' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:addMaterial)
  end
  
  it "should have 'addCategory' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:addCategory)
  end
  
  it "should have 'addMaterial!' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:addMaterial!)
  end
  
  it "should have 'addCategory!' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:addCategory!)
  end
  
  it "should have 'setParentCategory' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:setParentCategory)
  end
  
  it "should have 'setParentCategory!' method" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should respond_to(:setParentCategory!)
  end
  
  it "should have empty materials list, empty categories list and be a root category" do
    empty_material_category = MaterialCategory.new(@attr)
    empty_material_category.should be_materialsEmpty
    empty_material_category.should be_categoriesEmpty
    empty_material_category.should be_rootCategory
  end
  
  it "should accept a parent category if it has'nt already one" do
    sub_category = MaterialCategory.new(@attr)
    matCat = FactoryGirl.create(:material_category)
    sub_category.setParentCategory(matCat)
    sub_category.save
    sub_category.material_category.should be matCat
  end
  
  it "should reject a parent category if it has already one" do
    sub_category = MaterialCategory.new(@attr)
    matCat = FactoryGirl.create(:material_category)
    sub_category.setParentCategory(matCat)
    sub_category.save
    expect {sub_category.setParentCategory(FactoryGirl.create(:material_category))}.to raise_error
  end
  
  it "should accept new Material if empty" do
    empty_material_category = MaterialCategory.new(@attr)
    mat = FactoryGirl.create(:material)
    empty_material_category.addMaterial(mat)
    empty_material_category.save
    empty_material_category.materials.should include(mat)
  end
  
  it "should accept new Category if empty" do
    empty_material_category = MaterialCategory.new(@attr)
    matCat = FactoryGirl.create(:material_category)
    empty_material_category.addCategory(matCat)
    empty_material_category.save
    empty_material_category.material_categories.should include(matCat)
  end
  
  it "should reject new Category if already contains materials" do
    category_with_material = MaterialCategory.new(@attr)
    category_with_material.addMaterial(FactoryGirl.create(:material))
    expect {category_with_material.addCategory(FactoryGirl.create(:material_category))}.to raise_error
    #expect { raise StandardError }.to raise_error
  end
  
  it "should reject new Material if already contains sub categories" do
    category_with_subcategories = MaterialCategory.new(@attr)
    category_with_subcategories.addCategory(FactoryGirl.create(:material_category))
    expect {category_with_subcategories.addMaterial(FactoryGirl.create(:material))}.to raise_error
    #expect { raise StandardError }.to raise_error
  end
end
