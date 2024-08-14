# frozen_string_literal: true

# app/interactions/users/create.rb
module Users
  class Create < ActiveInteraction::Base
    string :name
    string :surname
    string :patronymic, default: nil
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: []
    array :skills, default: []

    validates :name, :surname, :email, :age, :nationality, :country, :gender, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 90 }
    validates :gender, inclusion: { in: %w[male female other] }

    validate :validate_interests
    validate :validate_skills

    def execute
      user = User.new(
        name:,
        surname:,
        patronymic:,
        fullname: build_fullname,
        email:,
        age:,
        nationality:,
        country:,
        gender:
      )

      if user.save
        create_interests(user)
        create_skills(user)
        user
      else
        errors.merge!(user.errors)
        nil
      end
    end

    private

    def build_fullname
      [name, patronymic, surname].compact.join(' ')
    end

    def create_interests(user)
      interests.each do |interest_name|
        interest = Interest.find_or_create_by(name: interest_name)
        user.interests << interest
      end
    end

    def create_skills(user)
      skills.each do |skill_name|
        skill = Skill.find_or_create_by(name: skill_name)
        user.skills << skill
      end
    end

    def validate_interests
      errors.add(:interests, 'must be an array of strings') unless interests.all?(String)
    end

    def validate_skills
      errors.add(:skills, 'must be an array of strings') unless skills.all?(String)
    end
  end
end
