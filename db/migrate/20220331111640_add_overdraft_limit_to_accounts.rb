class AddOverdraftLimitToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :overdraft_limit, :decimal, default: 0, precision: 15, scale: 10
  end
end
