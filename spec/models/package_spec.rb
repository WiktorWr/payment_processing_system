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

  before do
    stub_request(:post, "https://api.stripe.com/v1/products")
      .to_return(
        status:  200,
        body:    { id: "prod_test_id" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    stub_request(:post, "https://api.stripe.com/v1/prices")
      .to_return(
        status:  200,
        body:    { id: "price_test_id" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

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

  describe "Stripe integration" do
    subject(:package) { build(:package, stripe_price_id: nil, stripe_product_id: nil) }

    context "when Stripe API succeeds" do
      it "sets stripe_product_id and stripe_price_id after validation" do
        package.valid?
        expect(package.stripe_product_id).to eq("prod_test_id")
        expect(package.stripe_price_id).to eq("price_test_id")
      end
    end

    context "when Stripe Product creation fails" do
      before do
        allow(Stripe::Product).to receive(:create).and_raise(Stripe::InvalidRequestError.new("Invalid parameters", "param"))
      end

      it "does not set stripe_product_id or stripe_price_id" do
        package.valid?
        expect(package.stripe_product_id).to be_nil
        expect(package.stripe_price_id).to be_nil
      end

      it "adds an error to the model" do
        package.valid?
        expect(package.errors[:base]).to include("Stripe API error: Invalid parameters")
      end

      it "prevents the model from being saved" do
        expect(package.save).to be false
      end
    end

    context "when Stripe Price creation fails" do
      before do
        allow(Stripe::Price).to receive(:create).and_raise(Stripe::InvalidRequestError.new("Invalid parameters", "param"))
      end

      it "does not set stripe_product_id or stripe_price_id" do
        package.valid?
        expect(package.stripe_product_id).to be_nil
        expect(package.stripe_price_id).to be_nil
      end

      it "adds an error to the model" do
        package.valid?
        expect(package.errors[:base]).to include("Stripe API error: Invalid parameters")
      end

      it "prevents the model from being saved" do
        expect(package.save).to be false
      end
    end
  end
end
