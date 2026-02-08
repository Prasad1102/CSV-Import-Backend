class Import < ApplicationRecord
    has_one_attached :file
    enum :status, [:pending, :processing, :failed, :completed, :completed_with_errors]

    validates :file, presence: true
end
