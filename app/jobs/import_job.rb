require 'csv'

class ImportJob < ApplicationJob
  # include Sidekiq::Job
  
  queue_as :default

  def perform(id)
    import = Import.find(id)
    import.processing!

    batch_size = 100
    failed_count = 0
    process_count = 0
    total_count = 0
    records = []
    import_errors = []

    begin
      import.file.open do |temp_file|
        CSV.foreach(temp_file.path, headers: true) do |row|
          total_count += 1

          valid, errors = validate_record(row)
          if valid
            records << {
              email: row['email'].strip.downcase,
              first_name: row['first_name'].strip,
              last_name: row['last_name'].strip,
              mobile: row['mobile'].strip,
              role: row['role'].strip.to_i,
              joining_date: row['joining_date'].strip
            }
          else
            failed_count += 1
            import_errors << { total_count + 1 => errors } # adding +1 for header
          end

          if records.size >= batch_size
            Employee.upsert_all(records, unique_by: :email)
            records = []
            process_count += 100
          end
        end
      end

      status = if failed_count == 0
        Import::statuses[:completed]
      else 
        Import::statuses[:completed_with_errors]
      end

      import.update(status:, failed_count:, total_count:, process_count:, import_errors:)
    rescue => e
      import.failed!
      raise e
    end
  end

  private

  def validate_record(row)
    errors = {}

    unless row['mobile'].strip.present? && row['mobile'].match(/\A\d{10}\z/)
      errors["mobile"] = 'Mobile Number is Not Valid'
    end

    if row['email'].blank?
      errors["email"] = "Email can't be blank"
    elsif row['email'].strip.length < 5
      errors["email"] = "Email length should be greater than or equal to 5"
    elsif !row['email'].strip.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      errors["email"] = "Email is not valid"
    end

    if row['first_name'].blank?
      errors["first_name"] = "First Name can't be blank"
    elsif row['first_name'].strip.length < 3
      errors["first_name"] = "First name should be atleast 3 character long"
    end

    [errors.blank?, errors]
  end
end
