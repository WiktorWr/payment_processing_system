# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  order_status      :enum             default("pending"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  package_id        :bigint           not null
#  stripe_payment_id :string
#  user_id           :bigint           not null
#
# Indexes
#
#  index_orders_on_package_id         (package_id)
#  index_orders_on_stripe_payment_id  (stripe_payment_id) UNIQUE
#  index_orders_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (package_id => packages.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Order, type: :model do
  subject(:order) { build(:order) }

  describe "validations" do
    it "is valid with default factory attributes" do
      expect(order).to be_valid
    end

    it "is valid with paid trait" do
      paid_order = build(:order, :paid)
      expect(paid_order).to be_valid
    end

    context "when stripe_payment_id already exists" do
      before do
        other_order = create(:order, stripe_payment_id: "order-id")
        order.stripe_payment_id = other_order.stripe_payment_id
        order.valid?
      end

      it "is invalid" do
        expect(order).not_to be_valid
      end

      it "contains proper error message" do
        expect(order.errors[:stripe_payment_id]).to include(I18n.t("errors.messages.taken"))
      end
    end
  end
end
