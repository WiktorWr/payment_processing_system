# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  stripe_customer_id :string
#
# Indexes
#
#  index_users_on_email               (email) UNIQUE
#  index_users_on_stripe_customer_id  (stripe_customer_id) UNIQUE
#
FactoryBot.define do
  factory :user do
    email              { Faker::Internet.unique.email }
    stripe_customer_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3) }

    trait :without_stripe_customer_id do
      stripe_customer_id { nil }
    end
  end
end
