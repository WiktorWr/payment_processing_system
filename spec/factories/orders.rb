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
FactoryBot.define do
  factory :order do
    association :user
    association :package

    stripe_payment_id { nil }
    order_status      { Order::ORDER_STATUS[:pending] }

    trait :paid do
      order_status      { Order::ORDER_STATUS[:paid] }
      stripe_payment_id { "stripe_payment_#{SecureRandom.hex(8)}" }
    end

    trait :canceled do
      order_status { Order::ORDER_STATUS[:canceled] }
    end
  end
end
