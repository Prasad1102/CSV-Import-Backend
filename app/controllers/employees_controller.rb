class EmployeesController < ApplicationController
    def index
        search = params[:search].downcase
        if search.present?
            @employees = Employee.joins(:compony)
                                .where("lower(employees.first_name) like '%#{search}%' OR lower(componies.name) like '%#{search}%'")
                                .page(params[:page])
                                .per(params[:per_page] || 10)
        else
            @employees = Employee.page(params[:page]).per(params[:per_page] || 10)
        end

        render json: {
            employees: @employees,
            meta: {
                current_page: @employees.current_page,
                total_pages: @employees.total_pages,
                total_count: @employees.total_count
            }
        }
    end
end