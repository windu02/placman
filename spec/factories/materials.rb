# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :material do |m|
    m.denomination { Faker::Lorem.words.join }
    m.unit "Unit"
  end
  
  factory :invalid_material, parent: :material do |m|
    m.denomination ""
    m.unit ""
  end
end