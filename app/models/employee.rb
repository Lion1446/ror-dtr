class Employee < ApplicationRecord
  belongs_to :department
  has_many :log_records, dependent: :destroy
end
