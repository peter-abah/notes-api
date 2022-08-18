class Collection < ApplicationRecord
  self.implicit_order_column = "created_at"

  validates :name, presence: true
  
  belongs_to :user
  has_many :notes, dependent: :destroy
end
