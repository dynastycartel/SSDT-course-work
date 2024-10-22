class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true, index: true
      t.string :username, null: false, default: ''
      t.string :password_digest, null: false
      t.string :secret_word, null: false
      t.boolean :superuser, null: false, default: false
      t.integer :balance, default: 50
      t.text :bio
      t.float :score, limit: 5, default: 0
      t.integer :reports, default: 0
      t.boolean :banned, default: false
    end
  end
end
