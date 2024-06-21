class Api::V1::EmployeesController < Api::V1::BaseController
  include Pagy::Backend

  before_action :find_employee, only: [:show, :update, :destroy]

  api :GET, "/employees", "Get a paginated list of employees"
  param :page, :number, desc: "Page number for pagination", required: false
  param :items, :number, desc: "Number of items per page", required: false
  returns code: 200, desc: "OK"
  returns code: 500, desc: "Internal Server Error"
  
  def index
    pagy, employees = pagy(Employee.all, items: params[:items] || 10)
    render json: {
      employees: Api::V1::EmployeeSerializer.new(employees).serializable_hash,
      pagination: pagy_metadata(pagy)
    }, status: :ok
  end

  api :POST, "/employees", "Create a new employee"
  param :employee, Hash, desc: "Employee information", required: true do
    param :name, String, desc: "Name of the employee", required: true
    param :department_id, :number, desc: "ID of the department the employee belongs to", required: true
  end
  returns code: 201, desc: "Created"
  returns code: 400, desc: "Bad Request"

  def create
    employee = Employee.new(employee_params)
    if employee.save
      render json: Api::V1::EmployeeSerializer.new(employee).serializable_hash, status: :created
    else
      render json: { error: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :GET, "/employees/:id", "Get a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  returns code: 200, desc: "OK"
  returns code: 404, desc: "Not Found"

  def show
    render json: Api::V1::EmployeeSerializer.new(@employee).serializable_hash, status: :ok
  end

  api :PATCH, "/employees/:id", "Update a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  param :employee, Hash, desc: "Employee information", required: true do
    param :name, String, desc: "Name of the employee", required: false
    param :department_id, :number, desc: "ID of the department the employee belongs to", required: false
  end
  returns code: 200, desc: "OK"
  returns code: 400, desc: "Bad Request"
  returns code: 404, desc: "Not Found"

  def update
    if @employee.update(employee_params)
      render json: Api::V1::EmployeeSerializer.new(@employee).serializable_hash, status: :ok
    else
      render json: { error: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/employees/:id", "Delete a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  returns code: 200, desc: "OK"
  returns code: 404, desc: "Not Found"

  def destroy
    if @employee.destroy
      render json: { message: "Successfully deleted employee with ID #{params[:id]}" }, status: :ok
    else
      render json: { error: "Failed to delete employee" }, status: :unprocessable_entity
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :department_id)
  end

  def find_employee
    @employee = Employee.find_by_id(params[:id])

    render json: { error: "Employee not found" }, status: :not_found if @employee.nil?
  end
end
