# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'creating a user with interests and skills' do
    let(:user_params) do
      {
        name: 'Halsey',
        surname: 'Parker',
        patronymic: 'Star',
        email: 'john.doe33@example.com',
        age: 10,
        nationality: 'American',
        country: 'USA',
        gender: 'female'
      }
    end

    let(:interests) { %w[Dancing Oceans] }
    let(:skills) { %w[Surfing Cooking] }

    it 'creates a user with associated interests and skills' do
      # Create a user with interests and skills
      result = Users::Create.run(params: user_params.merge(interests:, skills:))
      user = result.result

      # Check that the user is created
      expect(user).to be_persisted

      # Check that the user has the specified interests
      expect(user.interests.pluck(:name)).to match_array(interests)

      # Check that the user has the specified skills
      expect(user.skills.pluck(:name)).to match_array(skills)

      # Check that the interests and skills have the user's id
      user.interests.each do |interest|
        expect(interest.users.pluck(:id)).to include(user.id)
      end

      # Check that the interests and skills have the user's id
      user.skills.each do |skill|
        expect(skill.users.pluck(:id)).to include(user.id)
      end
    end
  end
end
