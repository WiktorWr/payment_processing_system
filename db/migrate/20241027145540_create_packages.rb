# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[7.2]
  def up
    create_enum "package_interval", %w[day week month year]
    create_enum "package_price_currency", %w[PLN USD]

    create_table :packages do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.enum :package_interval, enum_type: :package_interval, default: "month", null: false
      t.enum :package_price_currency, enum_type: :package_price_currency, default: "USD", null: false
      t.string :stripe_product_id, null: false
      t.string :stripe_price_id, null: false

      t.timestamps
    end

    add_index :packages, :name, unique: true
    add_index :packages, :stripe_product_id, unique: true
    add_index :packages, :stripe_price_id, unique: true
  end

  def down
    drop_table :packages
    drop_enum :package_interval
    drop_enum :package_price_currency
  end
end
