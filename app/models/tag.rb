class Tag < ApplicationRecord
  self.implicit_order_column = "created_at"

  validates :name, presence: true

  has_and_belongs_to_many :notes
  belongs_to :user
end
