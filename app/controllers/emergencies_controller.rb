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

  def update
    if forbidden_param?("update")
      unpermitted_param_response("update")
    else
      emergency&.update(emergency_params)
      return render json: emergency
    end
  end

  private

  def forbidden_param?(action)
    if action === "create"
      true if (
        emergency_params[:id] || 
        emergency_params[:resolved_at]
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
      elsif emergency_params[:resolved_at]
        render json: { :message => 'found unpermitted parameter: resolved_at' }, status: 422
      end   
    elsif action === "update"
      if emergency_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      end      
    end
  end

  def emergency
    @emergency ||= Emergency.find_by(code: params[:code])
  end

  def emergency_params
    params.require(:emergency).permit(:id, :code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
  end
end
