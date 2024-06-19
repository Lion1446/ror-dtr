class LogRecordsController < ApplicationController
    include Pagy::Backend
  
    def index
      @pagy, @log_records = pagy(LogRecord.all)
      render json: { log_records: @log_records, pagination: pagy_metadata(@pagy) }
    end
  
    def show
      @log_record = LogRecord.find(params[:id])
      render json: @log_record
    end
  
    def create
      @log_record = LogRecord.new(log_record_params)
      if @log_record.save
        render json: @log_record, status: :created
      else
        render json: @log_record.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @log_record = LogRecord.find(params[:id])
      if @log_record.update(log_record_params)
        render json: @log_record
      else
        render json: @log_record.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @log_record = LogRecord.find(params[:id])
      @log_record.destroy
      head :no_content
    end
  
    private
  
    def log_record_params
      params.require(:log_record).permit(:employee_id, :time_in, :time_out)
    end
end