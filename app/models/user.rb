# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :interests

  validates :name, presence: true
  validates :surname, presence: true
  validates :gender, presence: true, format: { with: /\A(male|female)\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
