# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.2]
  def up
    create_enum "order_status", %w[pending paid canceled]

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.string :stripe_payment_id
      t.enum :order_status, enum_type: :order_status, default: "pending", null: false

      t.timestamps
    end

    add_index :orders, :stripe_payment_id, unique: true
  end

  def down
    drop_table :orders
    drop_enum :order_status
  end
end
