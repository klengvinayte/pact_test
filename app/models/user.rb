# frozen_string_literal: true

# This model user is responsible for the relationship between users and skills and interests.
# It also contains validations for the user's attributes.
# It has a many-to-many relationship with skills and interests.
class User < ApplicationRecord
  has_many :interests_users, dependent: :destroy
  has_many :interests, through: :interests_users

  has_many :skills_users, dependent: :destroy
  has_many :skills, through: :skills_users

  validates :name, presence: true
  validates :surname, presence: true
  validates :patronymic, presence: true
  validates :age, presence: true,
                  numericality: { only_integer: true, less_than: 90, greater_than_or_equal_to: 0 }
  validates :nationality, presence: true
  validates :country, presence: true
  validates :gender, presence: true, format: { with: /\A(male|female)\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # def as_json(options = {})
  #   super(options.merge(include: { interests: { only: :name }, skills: { only: :name } }))
  # end
end
