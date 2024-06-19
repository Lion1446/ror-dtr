class CreateLogRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :log_records do |t|
      t.references :employee, null: false, foreign_key: true
      t.datetime :time_in
      t.datetime :time_out

      t.timestamps
    end
  end
end
