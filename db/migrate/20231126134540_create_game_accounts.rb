class CreateGameAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :game_accounts do |t|
      t.string :login, null: false, unique: true
      t.string :password_digest, null: false
      t.integer :user_id, default: nil
      t.integer :recommended_price, null: false
      t.boolean :selling, default: false
      t.boolean :confirmed, default: false
    end
  end
end
