# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_params) do
    {
      name: 'John',
      surname: 'Doe',
      patronymic: 'Smith',
      email: 'john.doe@example.com',
      age: 30,
      nationality: 'American',
      country: 'USA',
      gender: 'male',
      interests: %w[Reading Sports],
      skills: %w[Ruby Rails]
    }
  end

  let(:invalid_email_params) do
    valid_params.merge(email: 'invalid_email')
  end

  let(:missing_name_params) do
    valid_params.except(:name)
  end

  let(:negative_age_params) do
    valid_params.merge(age: -1)
  end

  describe 'with valid params' do
    let(:result) { described_class.run(valid_params) }
    let(:user) { result.result }

    it 'returns a valid result' do
      expect(result).to be_valid
    end

    it 'creates a user' do
      expect { result }.to change(User, :count).by(1)
    end

    it 'assigns the correct name' do
      expect(user.name).to eq('John')
    end

    it 'assigns the correct surname' do
      expect(user.surname).to eq('Doe')
    end

    it 'creates interests' do
      expect(user.interests.count).to eq(2)
    end

    it 'creates skills' do
      expect(user.skills.count).to eq(2)
    end
  end

  describe 'with invalid email' do
    let(:result) { described_class.run(invalid_email_params) }

    it 'returns an invalid result' do
      expect(result).not_to be_valid
    end

    it 'does not create a user' do
      expect { result }.not_to change(User, :count)
    end

    it 'returns email validation errors' do
      expect(result.errors.full_messages).to include('Email is invalid')
    end
  end

  describe 'with missing name' do
    let(:result) { described_class.run(missing_name_params) }

    it 'returns an invalid result' do
      expect(result).not_to be_valid
    end

    it 'does not create a user' do
      expect { result }.not_to change(User, :count)
    end

    it 'returns name presence errors' do
      expect(result.errors.full_messages).to include('Name is required')
    end
  end

  describe 'with negative age' do
    let(:result) { described_class.run(negative_age_params) }

    it 'returns an invalid result' do
      expect(result).not_to be_valid
    end

    it 'does not create a user' do
      expect { result }.not_to change(User, :count)
    end

    it 'returns age validation errors' do
      expect(result.errors.full_messages).to include('Age must be greater than or equal to 0')
    end
  end

  describe 'with partially existing interests and skills' do
    before do
      Interest.create(name: 'Reading')
      Skill.create(name: 'Ruby')
    end

    let(:result) { described_class.run(valid_params) }
    let(:user) { result.result }

    it 'does not create duplicate interests' do
      expect { result }.to change(Interest, :count).by(1) # Only "Sports" will be created
    end

    it 'does not create duplicate skills' do
      expect { result }.to change(Skill, :count).by(1) # Only "Rails" will be created
    end

    it 'assigns the correct interests to the user' do
      expect(user.interests.map(&:name)).to match_array(%w[Reading Sports])
    end

    it 'assigns the correct skills to the user' do
      expect(user.skills.map(&:name)).to match_array(%w[Ruby Rails])
    end
  end

  describe 'with invalid interests type' do
    let(:invalid_interests_params) { valid_params.merge(interests: ['Reading', 123]) }
    let(:result) { described_class.run(invalid_interests_params) }

    it 'returns an invalid result' do
      expect(result).not_to be_valid
    end

    it 'returns interests validation errors' do
      expect(result.errors.full_messages).to include('Interests must be an array of strings')
    end
  end

  describe 'with invalid skills type' do
    let(:invalid_skills_params) { valid_params.merge(skills: ['Ruby', 456]) }
    let(:result) { described_class.run(invalid_skills_params) }

    it 'returns an invalid result' do
      expect(result).not_to be_valid
    end

    it 'returns skills validation errors' do
      expect(result.errors.full_messages).to include('Skills must be an array of strings')
    end
  end
end
