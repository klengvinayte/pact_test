# frozen_string_literal: true

# spec/interactions/users/create_spec.rb
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
end
