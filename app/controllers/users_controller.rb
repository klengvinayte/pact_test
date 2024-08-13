# frozen_string_literal: true

# This controller is responsible for handling requests related to users.
class UsersController < ApplicationController
  # Only for testing purposes
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  # def create
  #   result = Users::Create.run(params: user_params.merge(interests: params[:interests] || [],
  #                                                        skills: params[:skills] || []))
  #
  #   if result.valid?
  #     @user = result.result
  #     redirect_to @user, notice: 'User was successfully created.'
  #   else
  #     flash.now[:alert] = result.errors.full_messages.to_sentence
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  def create
    result = Users::Create.run(params: user_params.merge(interests: params[:interests] || [],
                                                         skills: params[:skills] || []))

    if result.valid?
      @user = result.result
      if @user
        redirect_to @user, notice: 'User was successfully created.'
      else
        flash[:alert] = 'User creation failed.'
        render :new, status: :unprocessable_entity, notice: 'User creation failed.'
      end
    else
      @user = User.new(user_params)
      Rails.logger.error(result.errors.full_messages.join(', '))
      flash.now[:alert] = result.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :patronymic, :email, :age,
                                 :nationality, :country, :gender)
  end
end
