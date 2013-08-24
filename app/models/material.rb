# == Schema Information
#
# Table name: materials
#
#  id                   :integer          not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  denomination         :string(255)
#  unit                 :string(255)      default("Unit")
#  material_category_id :integer
#

class Material < ActiveRecord::Base
  validates :denomination, presence: true
  validates :unit, presence: true
  
  UNIT_OPTIONS = %w(Unit m&sup2;)
  validates :unit, :inclusion => {:in => UNIT_OPTIONS}
  
  belongs_to :material_category
end
