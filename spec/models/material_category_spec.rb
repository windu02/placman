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
  it "should create a new instance given a valid attribute" do
    @attr = {
      :name => "Placo"
    }
    MaterialCategory.create!(@attr)
  end
  
  it "has a valid Factory" do
    FactoryGirl.create(:material_category).should be_valid
  end

  it "should require a name" do
    FactoryGirl.build(:material_category, name: "").should_not be_valid
  end

  it "should have 'addMaterial' method" do
    FactoryGirl.build(:material_category).should respond_to(:addMaterial)
  end
  
  it "should have 'addCategory' method" do
    FactoryGirl.build(:material_category).should respond_to(:addCategory)
  end
  
  it "should have 'addMaterial!' method" do
    FactoryGirl.build(:material_category).should respond_to(:addMaterial!)
  end
  
  it "should have 'addCategory!' method" do
    FactoryGirl.build(:material_category).should respond_to(:addCategory!)
  end
  
  it "should have 'setParentCategory' method" do
    FactoryGirl.build(:material_category).should respond_to(:setParentCategory)
  end
  
  it "should have 'setParentCategory!' method" do
    FactoryGirl.build(:material_category).should respond_to(:setParentCategory!)
  end
  
  it "should have empty materials list, empty categories list and be a root category" do
    empty_material_category = FactoryGirl.build(:material_category)
    empty_material_category.should be_materialsEmpty
    empty_material_category.should be_categoriesEmpty
    empty_material_category.should be_rootCategory
  end
  
  it "should accept a parent category if it has not already one" do
    sub_category = FactoryGirl.build(:material_category)
    matCat = FactoryGirl.build(:material_category)
    sub_category.setParentCategory(matCat)
    sub_category.save
    sub_category.material_category.should be matCat
  end
  
  it "should reject a parent category if it has already one" do
    sub_category = FactoryGirl.build(:material_category)
    matCat = FactoryGirl.build(:material_category)
    sub_category.setParentCategory(matCat)
    sub_category.save
    expect {sub_category.setParentCategory(FactoryGirl.build(:material_category))}.to raise_error
  end
  
  it "should accept new Material if empty" do
    empty_material_category = FactoryGirl.build(:material_category)
    mat = FactoryGirl.build(:material)
    empty_material_category.addMaterial(mat)
    empty_material_category.save
    empty_material_category.materials.should include(mat)
  end
  
  it "should accept new Category if empty" do
    empty_material_category = FactoryGirl.build(:material_category)
    matCat = FactoryGirl.build(:material_category)
    empty_material_category.addCategory(matCat)
    empty_material_category.save
    empty_material_category.material_categories.should include(matCat)
  end
  
  it "should reject new Category if already contains materials" do
    category_with_material = FactoryGirl.build(:material_category)
    category_with_material.addMaterial(FactoryGirl.build(:material))
    expect {category_with_material.addCategory(FactoryGirl.build(:material_category))}.to raise_error
    #expect { raise StandardError }.to raise_error
  end
  
  it "should reject new Material if already contains sub categories" do
    category_with_subcategories = FactoryGirl.build(:material_category)
    category_with_subcategories.addCategory(FactoryGirl.build(:material_category))
    expect {category_with_subcategories.addMaterial(FactoryGirl.build(:material))}.to raise_error
    #expect { raise StandardError }.to raise_error
  end
end
