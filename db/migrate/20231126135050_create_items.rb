class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.belongs_to :game_account, foreign_key: true
      t.string :game, null: false
      t.string :name, null: false
      t.string :rarity, null: false
      t.integer :recommended_price, null: false
      t.boolean :selling, default: false
    end
  end
end
