class Employee < ApplicationRecord
    enum :role, [:admin, :manager, :employee]

    validates :email, presence: true,
            length: { minimum: 5, message: "must be at least 5 characters" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email" }
    validates :mobile, presence: true, format: { with: /\A\d{10}\z/, message: "should be exactly 10 digits and only numbers" }
end
