class CreateExchangeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_items do |t|
      t.belongs_to :posted_item, foreign_key: {to_table: :items}
      t.string :desired_item_name, null: false
      t.timestamp :publish_datetime
    end
  end
end
