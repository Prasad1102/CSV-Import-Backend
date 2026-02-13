require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "validations" do
    it "is invalid without email" do
      employee = Employee.new(first_name: "prasad", mobile: "8080398067")
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("can't be blank")
    end

    it "is valid without first name" do
      employee = Employee.new(mobile: "8080398067", email: "pds@gmail.com")
      expect(employee).not_to be_valid
      expect(employee.errors[:first_name]).to include("can't be blank")
    end

    it "is valid < 3 character first name" do
      employee = Employee.new(mobile: "8080398067", email: "pds@gmail.com", first_name: "aa")
      expect(employee).not_to be_valid
      expect(employee.errors[:first_name]).to include("must be at least 3 characters")
    end
  end
end
