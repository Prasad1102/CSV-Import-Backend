require 'csv'

class ImportJob < ApplicationJob
  queue_as :default

  def perform(id)
    import = Import.find(id)
    import.processing!

    failed_count = 0
    process_count = 0
    total_count = 0
    begin
      CSV.parse(import.file.download, headers: true) do |row|
        total_count = total_count + 1
        emp = Employee.new(
          email: row['email'].strip, 
          first_name: row['first_name'].strip,
          last_name: row['last_name'].strip, 
          mobile: row['mobile'].strip, 
          role: row['role'].strip.to_i, 
          joining_date: row['joining_date'].strip
        )

        if emp.save
          process_count += 1
        else
          failed_count += 1
        end
      end

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
      debugger
      import.failed!
    end
  end
end
