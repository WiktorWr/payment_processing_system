# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :stripe_customer_id

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :stripe_customer_id, unique: true
  end
end
