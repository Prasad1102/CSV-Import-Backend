require 'csv'

class ImportJob < ApplicationJob
  queue_as :default

  def perform(id)
    import = Import.find(id)
    import.processing!

    batch_size = 100

    failed_count = 0
    process_count = 0
    total_count = 0
    row_count = 0
    records = []
    errors = []
    begin
      CSV.parse(import.file.download, headers: true) do |row|
        total_count += 1
        row_count += 1

        valid, error = validate_record(row)
        if valid
          records << {
            email: row['email'].strip,
            first_name: row['first_name'].strip,
            last_name: row['last_name'].strip,
            mobile: row['mobile'].strip,
            role: row['role'].strip.to_i,
            joining_date: row['joining_date'].strip
          }
        else
          failed_count += 1
          errors << { row_count => error }
        end

        if records.size >= batch_size
          Employee.upsert_all(records, unique_by: :email)
          records = []
          process_count += 100
        end
      end

      import.update(import_errors: errors)

      status = if failed_count == 0
        Import::statuses[:completed]
      else 
        Import::statuses[:completed_with_errors]
      end

      import.update(
        status: ,
        failed_count: failed_count,
        total_count: total_count,
        process_count: process_count,
      )
    rescue => e
      import.failed!
    end
  end

  private

  def validate_record(row)
    if row['email'].strip.present? && row['email'].strip.length >= 5 && row['email'].strip.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      return false, {email: "Email Is Not Valid"}
    elsif row['mobile'].strip.present? && row['mobile'].match(/\A\d{10}\z/)
      return false, {mobile: "Mobile Number is Not Valid"}
    else
      return true, "Success"
    end
  end
end
