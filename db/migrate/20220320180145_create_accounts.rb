class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :title, index: true
      t.decimal :amount, precision: 15, scale: 10
      t.string :iban, index: { unique: true }
      t.references :user, null: false, foreign_key: true
      t.integer :lock_version, default: 0

      t.timestamps
    end
  end
end
