class Comment < ApplicationRecord
	belongs_to :user, optional: true
	validates :score, comparison: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}, numericality: { only_integer: true }
end
