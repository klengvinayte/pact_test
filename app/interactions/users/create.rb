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
      existing_interests = Set.new

      # Using batch processing to load existing interests
      Interest.find_each(batch_size: 1000) do |interest|
        existing_interests.add(interest.name)
      end

      # existing_interests = Interest.where(name: interests).pluck(:name).to_set

      new_interests = interests.reject do |interest_name|
        existing_interests.include?(interest_name)
      end

      # Mass creation of new interests
      Interest.create(new_interests.map { |name| { name: } }) if new_interests.any?

      user.interests << Interest.where(name: interests)
    end

    def create_skills(user)
      existing_skills = Set.new

      # Using batch processing to load existing skills
      Skill.find_each(batch_size: 1000) do |skill|
        existing_skills.add(skill.name)
      end

      # existing_skills = Skills.where(name: skills).pluck(:name).to_set

      # Filter out existing skills
      new_skills = skills.reject { |skill_name| existing_skills.include?(skill_name) }

      # Mass creation of new skills
      Skill.create(new_skills.map { |name| { name: } }) if new_skills.any?

      # Associate the user with the skills
      user.skills << Skill.where(name: skills)
    end

    def validate_interests
      errors.add(:interests, 'must be an array of strings') unless interests.all?(String)
    end

    def validate_skills
      errors.add(:skills, 'must be an array of strings') unless skills.all?(String)
    end
  end
end
