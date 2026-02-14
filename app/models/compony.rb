class Compony < ApplicationRecord
    has_many :employees, dependent: :destroy
end
