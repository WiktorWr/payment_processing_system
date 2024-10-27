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
class Package < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  PACKAGE_INTERVALS = {
    day:   "day",
    week:  "week",
    month: "month",
    year:  "year"
  }.freeze

  PACKAGE_PRICE_CURRENCIES = {
    pln: "PLN",
    usd: "USD"
  }.freeze

  enum :package_interval,       PACKAGE_INTERVALS
  enum :package_price_currency, PACKAGE_PRICE_CURRENCIES
end
