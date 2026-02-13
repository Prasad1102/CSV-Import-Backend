require 'rails_helper'

RSpec.describe "Employees API", type: :request do
  describe "GET index" do
    before do
      5.times do |i|
        Employee.create!(
          email: "user#{i}@example.com",
          first_name: "User#{i}",
          mobile: "98765432#{i}#{i}",
          role: "employee"
        )
      end
    end

    it "returns correct number of records for page 1" do
      get "/employees", params: { page: 1, per_page: 2 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end

    # it "returns correct number of records for page 3" do
    #   get "/employees", params: { page: 3, per_page: 2 }
    #   json = JSON.parse(response.body)
    #   expect(json.length).to eq(1)
    # end
  end
end