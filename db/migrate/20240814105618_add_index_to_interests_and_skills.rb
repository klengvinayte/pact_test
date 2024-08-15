# frozen_string_literal: true

class AddIndexToInterestsAndSkills < ActiveRecord::Migration[7.1]
  def change
    add_index :interests, :name, unique: true
    add_index :skills, :name, unique: true
  end
end
