class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all

    render json: emergencies
  end

  def create
    if forbidden_param?("create")
      unpermitted_param_response("create")
    else
      emergency = Emergency.new(emergency_params)

      if emergency.save
        render json: emergency, status: 201
      else
        render json: emergency.errors, status: 422
      end
    end
  end

  private

  def forbidden_param?(action)
    if action === "create"
      true if (
        emergency_params[:id]
      )
    elsif action === "update"
      true if (
        emergency_params[:id]
      )
    end
  end

  def unpermitted_param_response(action)
    if action === "create"
      if emergency_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      end   
    elsif action === "update"
      if emergency_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      end      
    end
  end

  def emergency
    @emergency_code ||= Emergency.find(params[:id])
  end

  def emergency_params
    params.require(:emergency).permit(:id, :code, :fire_severity, :police_severity, :medical_severity)
  end
end
