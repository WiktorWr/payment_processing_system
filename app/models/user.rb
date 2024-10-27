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
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :stripe_customer_id, uniqueness: true, allow_nil: true
end
