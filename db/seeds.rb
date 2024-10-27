# frozen_string_literal: true

User.find_or_create_by(email: "email@example.com")

Package.find_or_create_by(
  name:                   "Basic",
  package_interval:       Package::PACKAGE_INTERVALS[:month],
  price:                  1000,
  package_price_currency: Package::PACKAGE_PRICE_CURRENCIES[:usd],
)
