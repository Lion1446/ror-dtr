class Api::V1::DepartmentsController < Api::V1::BaseController
  include Pagy::Backend

  before_action :find_department, only: [:show, :update, :destroy]

  api :GET, "/departments", "Get a paginated list of departments"
  param :page, :number, desc: "Page number for pagination"
  param :items, :number, desc: "Number of items per page", required: false
  returns code: 200, desc: "OK"
  returns code: 500, desc: "Internal Server Error"

  def index
    pagy, departments = pagy(Department.all, items: params[:items] || 10)
    render json: {
      departments: Api::V1::DepartmentSerializer.new(departments).serializable_hash,
      pagination:  pagy_metadata(pagy)
    }, status: :ok
  end

  api :POST, "/departments", "Create a new department"
  param :department, Hash, desc: "Department information", required: true do
    param :name, String, desc: "Name of the department", required: true
  end
  returns code: 201, desc: "Created"
  returns code: 400, desc: "Bad Request"

  def create
    department = Department.new(department_params)
    if department.save
      render json: Api::V1::DepartmentSerializer.new(department).serializable_hash, status: :created
    else
      render json: { error: department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :GET, "/departments/:id", "Get a specific department"
  param :id, :number, desc: "ID of the department", required: true
  returns code: 200, desc: "OK"
  returns code: 404, desc: "Not Found"

  def show
    render json: Api::V1::DepartmentSerializer.new(@department).serializable_hash, status: :ok
  end

  api :PATCH, "/departments/:id", "Update a specific department"
  param :id, :number, desc: "ID of the department", required: true
  param :department, Hash, desc: "Department information", required: true do
    param :name, String, desc: "Name of the department", required: true
  end
  returns code: 200, desc: "OK"
  returns code: 400, desc: "Bad Request"
  returns code: 404, desc: "Not Found"

  def update
    if @department.update(department_params)
      render json: Api::V1::DepartmentSerializer.new(@department).serializable_hash, status: :ok
    else
      render json: { error: @department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/departments/:id", "Delete a specific department"
  param :id, :number, desc: "ID of the department", required: true
  returns code: 204, desc: "No Content"
  returns code: 404, desc: "Not Found"

  def destroy
    if @department.destroy
      render json: { message: "Successfully deleted department with ID #{params[:id]}" }, status: :ok
    else
      render json: { error: "Failed to delete department" }, status: :unprocessable_entity
    end
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end

  def find_department
    @department = Department.find_by_id(params[:id])

    render json: { error: "Department not found" }, status: :not_found if @department.nil?
  end
end
