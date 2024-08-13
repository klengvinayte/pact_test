# frozen_string_literal: true

# This interaction is responsible for creating a new user.
# It validates the input parameters, creates a new user, and updates the user's interests and skills.
# If the email already exists, the interaction stops the execution and returns an error.
# If the age is not between 1 and 89, the interaction stops the execution and returns
module Users
  class Create < ActiveInteraction::Base
    hash :params do
      string :name
      string :surname
      string :patronymic, default: nil
      string :email
      integer :age
      string :nationality, default: ''
      string :country
      string :gender
      array :interests, default: []
      array :skills, default: []
    end

    def execute
      return unless required_params_present?
      # Stop the execution if the email already exists
      return unless check_email_exists!
      return unless valid_age?(params['age'])
      return unless valid_gender?(params['gender'])

      user_full_name = "#{params['surname']} #{params['name']} #{params['patronymic']}".strip
      user_params = params.except(:interests, :skills).merge(fullname: user_full_name)
      user = User.new(user_params)

      ActiveRecord::Base.transaction do
        user.save!
        update_interests(user)
        update_skills(user)
      end

      user
    end

    def check_email_exists!
      if User.exists?(email: params['email'])
        errors.add(:email, 'has already been taken')
        return false # return false to stop the execution
      end
      true
    end

    private

    def required_params_present?
      params['name'].present? &&
        params['surname'].present? &&
        params['patronymic'].present? &&
        params['email'].present? &&
        params['age'].present? &&
        params['nationality'].present? &&
        params['country'].present? &&
        params['gender'].present?
    end

    def valid_age?(age)
      if age.positive? && age < 90
        true
      else
        errors.add(:age, 'must be between 1 and 89')
        false
      end
    end

    def valid_gender?(gender)
      if %w[male female].include?(gender)
        true
      else
        errors.add(:gender, 'must be male or female')
        false
      end
    end

    def update_interests(user)
      interest_names = params['interests'].map(&:strip).uniq
      existing_interests = Interest.where(name: interest_names).to_a

      # Search for missing interests and create them
      new_interests = interest_names - existing_interests.map(&:name)
      created_interests = new_interests.map { |name| Interest.create(name:) }

      # Combine existing and new interests
      user.interests = existing_interests + created_interests
    end

    def update_skills(user)
      skill_names = params['skills'].map(&:strip).uniq
      existing_skills = Skill.where(name: skill_names).to_a

      # Search for missing skills and create them
      new_skills = skill_names - existing_skills.map(&:name)
      created_skills = new_skills.map { |name| Skill.create(name:) }

      # Combine existing and new skills
      user.skills = existing_skills + created_skills
    end
  end
end
