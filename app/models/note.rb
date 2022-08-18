class Note < ApplicationRecord
  self.implicit_order_column = "created_at"

  validates :title, presence: true
  validates :content, presence: true
  belongs_to :user
end
