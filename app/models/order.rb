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
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :package

  validates :stripe_payment_id, uniqueness: true, allow_nil: true

  ORDER_STATUS = {
    pending:  "pending",
    paid:     "paid",
    canceled: "canceled"
  }.freeze

  enum :order_status, ORDER_STATUS
end
