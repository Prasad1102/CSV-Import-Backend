class ImportsController < ApplicationController
    def create
        @import =Import.new(file: params[:file])
        if @import.save
            ImportJob.perform_later(@import.id)

            render json: {
            id: @import.id,
            }, status: :created
        else
            render json: @import.errors, status: :unprocessable_entity
        end
    end

    def index
        @imports = Import.page(params[:page]).per(params[:per_page])
        render json: {
            imports: @imports,
            meta: {
                current_page: @imports.current_page,
                total_pages: @imports.total_pages,
                total_count: @imports.total_count
            }
        }
    end

    def show
        @import = Import.find(params[:id])
        render json: {
            id: @import.id,
            status: @import.status,
            failed_count: @import.failed_count,
            total_count: @import.total_count,
            process_count: @import.process_count,
            import_errors: @import.import_errors,
            file_url: rails_blob_url(@import.file)  
        }
    end
end