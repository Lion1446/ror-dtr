class Department < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
