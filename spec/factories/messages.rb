# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user nil
    body "MyText"
    attach_path "MyText"
    attach_size "MyText"
    room nil
  end
end
