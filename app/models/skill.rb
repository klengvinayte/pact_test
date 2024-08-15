# frozen_string_literal: true

# This model is responsible for the relationship between users and skills.
class Skill < ApplicationRecord
  has_many :skills_users, dependent: :destroy
  has_many :users, through: :skills_users

  validates :name, presence: true, uniqueness: true
end
