# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'John',
      surname: 'Doe',
      patronymic: 'Smith',
      email: 'john.doe@example.com',
      age: 30,
      nationality: 'American',
      country: 'USA',
      gender: 'male'
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      surname: '',
      email: 'invalid_email',
      age: 150,
      nationality: '',
      country: '',
      gender: 'unknown'
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      User.create! valid_attributes
      get :index
      expect(response).to be_successful # response.success? is deprecated in Rails 5.0
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new User' do
        post :create, params: { user: invalid_attributes }
        expect(User.count).to eq(0)
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end
end
