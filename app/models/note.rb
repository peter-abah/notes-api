class Note < ApplicationRecord
  self.implicit_order_column = "created_at"

  validates :title, presence: true
  validates :content, presence: true

  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :collection, optional: true
end
