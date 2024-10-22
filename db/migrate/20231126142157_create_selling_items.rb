class CreateSellingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :selling_items do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :seller_account, foreign_key: {to_table: :game_accounts}
      t.integer :price
      t.timestamp :publish_datetime
    end
  end
end
