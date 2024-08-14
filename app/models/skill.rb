# frozen_string_literal: true

# This model is responsible for the relationship between users and skills.
class Skill < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true
end
