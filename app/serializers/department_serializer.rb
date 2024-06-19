class DepartmentSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  attributes :id, :name
  has_many :employees
end
