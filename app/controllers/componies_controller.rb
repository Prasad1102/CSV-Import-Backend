class ComponiesController < ApplicationController
  def index
    @componies = Compony.all

    result = @componies.map do |company|
      {
        id: company.id,
        name: company.name,
        ceo: company.ceo,
        head_office: company.head_office,
        website: company.website,
        established_date: company.established_date,
        employee_count: company.employees_count
      }
    end

    render json: result
  end
end