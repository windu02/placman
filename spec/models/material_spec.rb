require 'spec_helper'

describe Material do
  before(:each) do
    @attr = {
      :denomination => "plaque de placo",
      :unit => "unit"
    }
  end

  it "should create a new instance given a valid attribute" do
    Material.create!(@attr)
  end

  it "should require a denomination" do
    no_denomination_material = Material.new(@attr.merge(:denomination => ""))
    no_denomination_material.should_not be_valid
  end

  it "should accept any allowed 'units'" do
    units = %w[Unit m&sup2;]
    units.each do |unit|
      valid_unit_material = Material.new(@attr.merge(:unit => unit))
      valid_unit_material.should be_valid
    end
  end
  
  it "should reject any non allowed 'units'" do
    units = %w[Plaque m&sup3;]
    units.each do |unit|
      invalid_unit_material = Material.new(@attr.merge(:unit => unit))
      invalid_unit_material.should_not be_valid
    end
  end
end
