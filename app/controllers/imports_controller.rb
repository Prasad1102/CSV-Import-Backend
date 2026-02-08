class ImportsController < ApplicationController
    def create
        @import =Import.new(file: params[:file])
        if @import.save
            render json: {
            id: @import.id,
            }, status: :created
        else
            render json: @import.errors, status: :unprocessable_entity
        end
    end

    def show
        @import = Import.find(params[:id])
        if @import
            render json: {
                id: @import.id,
                status: @import.status,
                failed_count: @import.failed_count,
                total_count: @import.total_count,
                process_count: @import.process_count,
                file_url: rails_blob_url(@import.file)  
            }
        end
    end
end