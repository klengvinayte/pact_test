# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:params) do
    {
      name: 'John',
      surname: 'Doe',
      patronymic: 'Smith',
      email: 'john.doe@example.com',
      age: 25,
      nationality: 'American',
      country: 'USA',
      gender: 'male',
      interests: %w[reading coding],
      skills: %w[ruby rails]
    }
  end

  describe '#execute' do
    context 'with valid params' do
      it 'creates a new user' do
        expect { described_class.run(params:) }.to change(User, :count).by(1)
      end

      it 'saves the interests and skills' do
        result = described_class.run(params:)
        user = result.result
        expect(user.interests.map(&:name)).to match_array(%w[reading coding])
        expect(user.skills.map(&:name)).to match_array(%w[ruby rails])
      end
    end

    context 'with an existing email' do
      before { create(:user, email: params[:email]) }

      it 'does not create a new user' do
        result = described_class.run(params:)
        expect(result).to be_invalid
        expect(result.errors.full_messages).to include('Email has already been taken')
      end
    end

    context 'with invalid age' do
      it 'does not create a user if age is below 1' do
        params[:age] = 0
        result = described_class.run(params:)
        expect(result).to be_invalid
        expect(result.errors.full_messages).to include('Age must be between 1 and 89')
      end

      it 'does not create a user if age is 90 or above' do
        params[:age] = 90
        result = described_class.run(params:)
        expect(result).to be_invalid
        expect(result.errors.full_messages).to include('Age must be between 1 and 89')
      end
    end

    context 'with invalid gender' do
      it 'does not create a user if gender is not male or female' do
        params[:gender] = 'other'
        result = described_class.run(params:)
        expect(result).to be_invalid
        expect(result.errors.full_messages).to include('Gender must be male or female')
      end
    end

    context 'with missing required params' do
      it 'does not create a user' do
        params[:name] = nil
        result = described_class.run(params:)
        expect(result).to be_invalid
      end
    end
  end
end
