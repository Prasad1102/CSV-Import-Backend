class ImportsController < ApplicationController
    def create
        @import = Import.new(file: params[:file])

        if @import.save
            render json: {
            id: @import.id,
            }, status: :created
        else
            render json: @import.errors, status: :unprocessable_entity
        end
    end
end