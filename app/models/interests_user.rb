# frozen_string_literal: true

# This model is responsible for the relationship between users and interests.
class InterestsUser < ApplicationRecord
  belongs_to :user
  belongs_to :interest
end
