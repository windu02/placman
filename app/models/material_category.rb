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

class MaterialCategory < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :materials
  
  belongs_to :material_category
  has_many :material_categories
  
  def materialsEmpty?
    self.materials.empty?
  end
  
  def categoriesEmpty?
    self.material_categories.empty?
  end
  
  def rootCategory?
    self.material_category.nil?
  end
  
  def setParentCategory(cat)
    if self.rootCategory?
      self.material_category = cat
    else
      raise "Error: Category has already a parent category"
    end
  end
  
  def setParentCategory!(cat)
    self.setParentCategory(cat)
    self.save
  end
  
  def addMaterial(mat)
    if self.categoriesEmpty?
      self.materials.push(mat)
    else
      raise "Error: Category contains already subcategories"
    end
  end
  
  def addCategory(cat)
    if self.materialsEmpty?
      self.material_categories.push(cat)
    else
      raise "Error: Category contains already materials"
    end
  end
  
  def addMaterial!(mat)
    self.addMaterial(mat)
    self.save
  end
  
  def addCategory!(cat)
    self.addCategory(cat)
    self.save
  end
end
