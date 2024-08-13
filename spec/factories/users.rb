# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John' }
    surname { 'Doe' }
    patronymic { 'Smith' }
    email { 'john.doe@example.com' }
    age { 25 }
    nationality { 'American' }
    country { 'USA' }
    gender { 'male' }
  end
end
