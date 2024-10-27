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
require "rails_helper"

RSpec.describe Package, type: :model do
  subject(:package) { build(:package) }

  describe "validations" do
    it "is valid with default factory attributes" do
      expect(package).to be_valid
    end

    context "when name is nil" do
      before do
        package.name = nil
        package.valid?
      end

      it "is invalid" do
        expect(package).not_to be_valid
      end

      it "is contains proper error message" do
        expect(package.errors[:name]).to include(I18n.t("errors.messages.blank"))
      end
    end

    context "when name already exists" do
      before do
        create(:package, name: package.name)
        package.valid?
      end

      it "is invalid" do
        expect(package).not_to be_valid
      end

      it "contains proper error message" do
        expect(package.errors[:name]).to include(I18n.t("errors.messages.taken"))
      end
    end

    context "when price is nil" do
      before do
        package.price = nil
        package.valid?
      end

      it "is invalid" do
        expect(package).not_to be_valid
      end

      it "is contains proper error message" do
        expect(package.errors[:price]).to include(I18n.t("errors.messages.blank"))
      end
    end

    context "when price is not an integer" do
      before do
        package.price = 10.5
        package.valid?
      end

      it "is invalid" do
        expect(package).not_to be_valid
      end

      it "contains proper error message" do
        expect(package.errors[:price]).to include(I18n.t("errors.messages.not_an_integer"))
      end
    end

    context "when price is not greater than 0" do
      before do
        package.price = 0
        package.valid?
      end

      it "is invalid" do
        expect(package).not_to be_valid
      end

      it "contains proper error message" do
        expect(package.errors[:price]).to include(I18n.t("errors.messages.greater_than", count: 0))
      end
    end
  end
end
