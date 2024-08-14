# frozen_string_literal: true

# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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

  let(:invalid_params) do
    {
      name: '',
      surname: 'Doe',
      email: 'invalid_email',
      age: 30,
      nationality: 'American',
      country: 'USA',
      gender: 'male'
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        post :create, params: { user: valid_params }
      end

      it 'returns status created (201)' do
        expect(response).to have_http_status(201)
      end

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end

      it 'returns the correct user name' do
        expect(response.parsed_body['name']).to eq('John')
      end
    end

    context 'with invalid params' do
      before do
        post :create, params: { user: invalid_params }
      end

      it 'returns status unprocessable entity (422)' do
        expect(response).to have_http_status(422)
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'returns error messages' do
        expect(response.parsed_body['errors']).to include('Email is invalid',
                                                          "Name can't be blank")
      end
    end
  end
end
