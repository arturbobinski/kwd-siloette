module System
  class ServiceImagesController < System::BaseController

    def create
      params[:service_id] = nil if params[:service_id].to_i == 0
      @service_image = ServiceImage.new(service_id: params[:service_id], file: params[:file])
      if @service_image.save
        render json: {id: @service_image.id, url: @service_image.file.url(:medium)}, status: 200
      else
        render json: { error: @service_image.errors.full_messages.to_sentence }, status: 422
      end
    end

    def update
      if @service_image.update(file: params[:file])
        render json: {id: @service_image.id, url: @service_image.file.url(:medium)}, status: 200
      else
        render json: { error: @service_image.errors.full_messages.to_sentence }, status: 422
      end
    end

    def destroy
      @service_image.destroy
      render nothing: true, status: 200
    end
  end
end