# frozen_string_literal: true

# This model is responsible for the relationship between users and interests.
class Interest < ApplicationRecord
  has_many :interests_users, dependent: :destroy
  has_many :users, through: :interests_users

  validates :name, presence: true, uniqueness: true
end
