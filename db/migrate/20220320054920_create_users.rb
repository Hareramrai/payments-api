# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :token
      t.timestamp :token_expires_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :token, unique: true
  end
end
