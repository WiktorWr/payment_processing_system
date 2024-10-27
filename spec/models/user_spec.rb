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
require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validations" do
    it "is valid with default factory attributes" do
      expect(user).to be_valid
    end

    it "is valid with without_stripe_customer_id factory trait attributes" do
      user_without_stripe = build(:user, :without_stripe_customer_id)
      expect(user_without_stripe).to be_valid
    end

    context "when email is nil" do
      before do
        user.email = nil
        user.valid?
      end

      it "is invalid" do
        expect(user).not_to be_valid
      end

      it "is contains proper error message" do
        expect(user.errors[:email]).to include(I18n.t("errors.messages.blank"))
      end
    end

    context "when email already exists" do
      before do
        create(:user, email: user.email)
        user.valid?
      end

      it "is invalid" do
        expect(user).not_to be_valid
      end

      it "contains proper error message" do
        expect(user.errors[:email]).to include(I18n.t("errors.messages.taken"))
      end
    end

    context "when email is in invalid format" do
      before do
        user.email = "invalid_email"
        user.valid?
      end

      it "is invalid" do
        expect(user).not_to be_valid
      end

      it "contains proper error message" do
        expect(user.errors[:email]).to include(I18n.t("errors.messages.invalid"))
      end
    end

    context "when stripe_customer_id already exists" do
      before do
        create(:user, stripe_customer_id: user.stripe_customer_id)
        user.valid?
      end

      it "is invalid" do
        expect(user).not_to be_valid
      end

      it "contains proper error message" do
        expect(user.errors[:stripe_customer_id]).to include(I18n.t("errors.messages.taken"))
      end
    end
  end
end
