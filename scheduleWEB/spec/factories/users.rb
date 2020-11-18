FactoryBot.define do
  factory :user do
    name { "MyString" }
    password_digest { "MyString" }
    type { 1 }
    status { 1 }
    access_digest { "MyString" }
  end
end
