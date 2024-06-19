class Api::V1::LogRecordsController < Api::V1::BaseController
  include Pagy::Backend

  api :GET, "/api/v1/log_records", "Get a paginated list of log records"
  param :page, :number, desc: "Page number for pagination", required: false
  param :items, :number, desc: "Number of items per page", required: false
  returns code: 200, desc: "OK"
  returns code: 401, desc: "Unauthorized"
  returns code: 500, desc: "Internal Server Error"
  def index
    pagy, log_records = pagy(LogRecord.all, items: params[:items] || 10)
    render json: {
      log_records: LogRecordSerializer.new(log_records).serializable_hash,
      pagination:  pagy_metadata(pagy)
    }, status: :ok
  end

  api :POST, "/api/v1/log_records", "Create a new log record"
  param :log_record, Hash, desc: "Log record information", required: true do
    param :employee_id, :number, desc: "ID of the employee", required: true
    param :time_in, String, desc: "Time in (ISO 8601 format)", required: true
    param :time_out, String, desc: "Time out (ISO 8601 format)", required: false
  end
  returns code: 201, desc: "Created"
  returns code: 400, desc: "Bad Request"
  returns code: 401, desc: "Unauthorized"
  def create
    log_record = LogRecord.new(log_record_params)
    if log_record.save
      render json: LogRecordSerializer.new(log_record).serializable_hash, status: :created
    else
      render json: { error: log_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :GET, "/api/v1/log_records/:id", "Get a specific log record"
  param :id, :number, desc: "ID of the log record", required: true
  returns code: 200, desc: "OK"
  returns code: 404, desc: "Not Found"
  def show
    log_record = LogRecord.find(params[:id])
    render json: LogRecordSerializer.new(log_record).serializable_hash, status: :ok
  end

  api :PATCH, "/api/v1/log_records/:id", "Update a specific log record"
  param :id, :number, desc: "ID of the log record", required: true
  param :log_record, Hash, desc: "Log record information", required: true do
    param :employee_id, :number, desc: "ID of the employee", required: false
    param :time_in, String, desc: "Time in (ISO 8601 format)", required: false
    param :time_out, String, desc: "Time out (ISO 8601 format)", required: false
  end
  returns code: 200, desc: "OK"
  returns code: 400, desc: "Bad Request"
  returns code: 404, desc: "Not Found"
  def update
    log_record = LogRecord.find(params[:id])
    if log_record.update(log_record_params)
      render json: LogRecordSerializer.new(log_record).serializable_hash, status: :ok
    else
      render json: { error: log_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/api/v1/log_records/:id", "Delete a specific log record"
  param :id, :number, desc: "ID of the log record", required: true
  returns code: 204, desc: "No Content"
  returns code: 404, desc: "Not Found"
  def destroy
    log_record = LogRecord.find(params[:id])
    log_record.destroy
    head :no_content
  end

  private

  def log_record_params
    params.require(:log_record).permit(:employee_id, :time_in, :time_out)
  end
end
