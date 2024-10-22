class Item < ApplicationRecord
	belongs_to :game_account
	after_create :add_to_acc_recommended_price

	def add_to_acc_recommended_price
		@account = GameAccount.find_by(id: self.game_account_id)
		@account.recommended_price += self.recommended_price
		@account.save
	end
end
