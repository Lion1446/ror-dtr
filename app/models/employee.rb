class Employee < ApplicationRecord
  belongs_to :department
  has_many :log_records, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :department, presence: true
end
