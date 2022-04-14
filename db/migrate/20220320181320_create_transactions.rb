class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 15, scale: 10
      t.string :description
      t.references :account, index: true, foreign_key: true
      t.string :transaction_type, null: false
      t.timestamps
    end
  end
end
