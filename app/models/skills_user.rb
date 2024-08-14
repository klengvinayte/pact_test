# frozen_string_literal: true

# This model is responsible for the relationship between users and skills.
class SkillsUser < ApplicationRecord
  belongs_to :user
  belongs_to :skill
end
