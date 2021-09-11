class RespondersController < ApplicationController
  def index
    responders = Responder.all

    render json: responders
  end

  def create
    responder = Responder.new(responder_params)

    if responder.save
      render json: responder, status: 201
    else
      render json: responder.errors
    end
  end

  def responder
    @responder ||= Responder.find(params[:id])
  end

  def responder_params
    params.require(:responder).permit(:emergency_code, :type, :name, :capacity, :on_duty)
  end
end