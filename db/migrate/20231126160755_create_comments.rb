class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.belongs_to :commenting_user, foreign_key: {to_table: :users}
      t.belongs_to :commented_user, foreign_key: {to_table: :users}
      t.integer :score, limit: 5
      t.text :body
      t.boolean :support, default: false
      t.timestamp :publish_datetime
    end
  end
end
