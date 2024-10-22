class SellingAccount < ApplicationRecord
	belongs_to :game_account
	validates :price, comparison: { greater_than_or_equal_to: 0, message: 'не может быть отрицательной' }
end
