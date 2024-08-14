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

    let(:result) { Users::Create.run(user_params.merge(interests:, skills:)) }
    let(:user) { result.result }

    it 'creates a persisted user' do
      expect(user).not_to be_nil
      expect(user).to be_persisted
    end

    it 'associates the user with the correct interests' do
      expect(user.interests.pluck(:name)).to match_array(interests)
    end

    it 'associates the user with the correct skills' do
      expect(user.skills.pluck(:name)).to match_array(skills)
    end

    it 'associates the interests with the correct user id' do
      user.interests.each do |interest|
        expect(interest.users.pluck(:id)).to include(user.id)
      end
    end

    it 'associates the skills with the correct user id' do
      user.skills.each do |skill|
        expect(skill.users.pluck(:id)).to include(user.id)
      end
    end
  end
end
