class SellingItem < ApplicationRecord
	belongs_to :item
	validates :price, comparison: { greater_than_or_equal_to: 0, message: 'не может быть отрицательной' }
end
