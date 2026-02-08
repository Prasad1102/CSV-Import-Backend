class ApplicationController < ActionController::Base
  skip_forgery_protection
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private
  def record_not_found
    render json: {error: "Record Not Found"}, status: :not_found
  end
end
