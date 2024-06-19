class Api::V1::EmployeesController < Api::V1::BaseController
  include Pagy::Backend

  api :GET, "/employees", "Get a paginated list of employees"
  param :page, :number, desc: "Page number for pagination", required: false
  param :items, :number, desc: "Number of items per page", required: false
  returns code: 200, desc: "OK"
  returns code: 401, desc: "Unauthorized"
  returns code: 500, desc: "Internal Server Error"
  def index
    pagy, employees = pagy(Employee.all, items: params[:items] || 10)
    render json: {
      employees:  EmployeeSerializer.new(employees).serializable_hash,
      pagination: pagy_metadata(pagy)
    }, status: :ok
  end

  api :POST, "/employees", "Create a new employee"
  param :employee, Hash, desc: "Employee information", required: true do
    param :name, String, desc: "Name of the employee", required: true
    param :department_id, :number, desc:     "ID of the department the employee belongs to",
                                   required: true
  end
  returns code: 201, desc: "Created"
  returns code: 400, desc: "Bad Request"
  returns code: 401, desc: "Unauthorized"
  def create
    employee = Employee.new(employee_params)
    if employee.save
      render json: EmployeeSerializer.new(employee).serializable_hash, status: :created
    else
      render json: { error: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :GET, "/employees/:id", "Get a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  returns code: 200, desc: "OK"
  returns code: 404, desc: "Not Found"
  def show
    employee = Employee.find(params[:id])
    render json: EmployeeSerializer.new(employee).serializable_hash, status: :ok
  end

  api :PATCH, "/employees/:id", "Update a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  param :employee, Hash, desc: "Employee information", required: true do
    param :name, String, desc: "Name of the employee", required: false
    param :department_id, :number, desc:     "ID of the department the employee belongs to",
                                   required: false
  end
  returns code: 200, desc: "OK"
  returns code: 400, desc: "Bad Request"
  returns code: 404, desc: "Not Found"
  def update
    employee = Employee.find(params[:id])
    if employee.update(employee_params)
      render json: EmployeeSerializer.new(employee).serializable_hash, status: :ok
    else
      render json: { error: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/employees/:id", "Delete a specific employee"
  param :id, :number, desc: "ID of the employee", required: true
  returns code: 204, desc: "No Content"
  returns code: 404, desc: "Not Found"
  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    head :no_content
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :department_id)
  end
end
