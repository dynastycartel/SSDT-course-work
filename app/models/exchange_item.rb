class ExchangeItem < ApplicationRecord
	belongs_to :item, optional: true
	validates :desired_item_name, presence: true
end
