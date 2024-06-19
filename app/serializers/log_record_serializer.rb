class LogRecordSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  attributes :id, :employee_id, :time_in, :time_out
  belongs_to :employee
end
