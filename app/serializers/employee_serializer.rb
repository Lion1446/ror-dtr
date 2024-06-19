class EmployeeSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  attributes :id, :name, :department_id
  belongs_to :department
  has_many :log_records
end
