# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :material_category do |mc|
    mc.name {Faker::Lorem.word}
  end
  
  factory :invalid_material_category, parent: :material_category do |mc|
    mc.name ""
  end
end