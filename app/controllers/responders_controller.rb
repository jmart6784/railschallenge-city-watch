class RespondersController < ApplicationController
  def index
    responders = Responder.all

    render json: responders
  end

  def show
    if responder
      render json: responder
    else
      render json: { :message => "responder doesn't exist" }, status: 404
    end
  end

  def create
    if responder_params[:emergency_code]
      render json: { :message => 'found unpermitted parameter: emergency_code' }, status: 422
    elsif responder_params[:id]
      render json: { :message => 'found unpermitted parameter: id' }, status: 422
    elsif responder_params[:on_duty]
      render json: { :message => 'found unpermitted parameter: on_duty' }, status: 422
    else
      responder = Responder.new(responder_params)

      if responder.save
        render json: responder, status: 201
      else
        render json: responder.errors, status: 422
      end
    end
  end

  def update
    if forbidden_param?("update")
      unpermitted_param_response("update")
    else
      responder&.update(responder_params)
      return render json: {message: 'Responder edited!'}
    end
  end

  private

  def forbidden_param?(action)
    if action === "update"
      true if (
        responder_params[:emergency_code] || 
        responder_params[:id] || 
        responder_params[:type]
      )
    elsif false
      
    end
  end

  def unpermitted_param_response(action)
    if action === "create"

    elsif action === "update"
      if responder_params[:emergency_code]
        render json: { :message => 'found unpermitted parameter: emergency_code' }, status: 422
      elsif responder_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      elsif responder_params[:type]
        render json: { :message => 'found unpermitted parameter: type' }, status: 422
      end      
    end
  end

  def responder
    @responder ||= Responder.find_by(name: params[:name])
  end

  def responder_params
    params.require(:responder).permit(:id, :emergency_code, :type, :name, :capacity, :on_duty)
  end
end