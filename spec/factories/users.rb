FactoryGirl.define do
  factory :user do
    name 'test'
    email 'test@test.com'
    password 'password'
    role 0
    time_zone 'Moscow'
  end
end
