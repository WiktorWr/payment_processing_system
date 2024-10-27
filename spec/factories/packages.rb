# frozen_string_literal: true

# == Schema Information
#
# Table name: packages
#
#  id                     :bigint           not null, primary key
#  name                   :string           not null
#  package_interval       :enum             default("month"), not null
#  package_price_currency :enum             default("usd"), not null
#  price                  :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_price_id        :string           not null
#  stripe_product_id      :string           not null
#
# Indexes
#
#  index_packages_on_name               (name) UNIQUE
#  index_packages_on_stripe_price_id    (stripe_price_id) UNIQUE
#  index_packages_on_stripe_product_id  (stripe_product_id) UNIQUE
#
FactoryBot.define do
  factory :package do
    name                   { Faker::Commerce.unique.product_name }
    price                  { Faker::Number.between(from: 100, to: 10_000) }
    package_interval       { Package::PACKAGE_INTERVALS.keys.sample }
    package_price_currency { Package::PACKAGE_PRICE_CURRENCIES.keys.sample }
    stripe_price_id        { "price_#{Faker::Alphanumeric.alphanumeric(number: 14)}" }
    stripe_product_id      { "prod_#{Faker::Alphanumeric.alphanumeric(number: 14)}" }
  end
end
