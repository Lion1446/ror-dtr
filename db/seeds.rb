require 'faker'

# Clear existing data
LogRecord.destroy_all
Employee.destroy_all
Department.destroy_all

# Create Departments
departments = 5.times.map do
  Department.create!(
    name: Faker::Company.industry
  )
end

# Create Employees
employees = 20.times.map do
  Employee.create!(
    name: Faker::Name.name,
    department: departments.sample
  )
end

# Create Log Records
employees.each do |employee|
  10.times do
    time_in = Faker::Time.backward(days: 5, period: :morning)
    time_out = time_in + rand(1..8).hours

    LogRecord.create!(
      employee: employee,
      time_in: time_in,
      time_out: time_out
    )
  end
end

puts "Seed data created successfully."
