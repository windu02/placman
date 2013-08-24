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

require 'spec_helper'

describe Material do
  
  it "should create a new instance given a valid attribute" do
    @attr = {
      :denomination => "plaque de placo",
      :unit => "Unit"
    }
    Material.create!(@attr)
  end
  
  it "has a valid Factory" do
    FactoryGirl.create(:material).should be_valid
  end

  it "should require a denomination" do
    FactoryGirl.build(:material, denomination: "").should_not be_valid
  end
  
  it "should require an unit" do
    FactoryGirl.build(:material, unit: "").should_not be_valid
  end

  it "should accept any allowed 'units'" do
    units = %w[Unit m&sup2;]
    units.each do |unit|
      FactoryGirl.build(:material, unit: unit).should be_valid
    end
  end
  
  it "should reject any non allowed 'units'" do
    units = %w[Plaque m&sup3;]
    units.each do |unit|
      FactoryGirl.build(:material, unit: unit).should_not be_valid
    end
  end
end
