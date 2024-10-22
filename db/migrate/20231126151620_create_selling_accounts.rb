class CreateSellingAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :selling_accounts do |t|
      t.belongs_to :game_account, foreign_key: true
      t.belongs_to :seller, foreign_key: {to_table: :users}
      t.integer :price
      t.timestamp :publish_datetime
    end
  end
end
