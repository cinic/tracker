# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_admin, :class => 'Admin::Admin' do
    name "Alexander Andreev"
    email "cinic.rus@gmail.com"
    password "password"
    role "0"
  end
end
