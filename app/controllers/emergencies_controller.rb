class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all

    render json: emergencies
  end

  private

  def emergency
    @emergency_code ||= Emergency.find(params[:id])
  end

  def emergency_params
    params.require(:emergency).permit(:id, :code, :fire_severity, :police_severity, :medical_severity)
  end
end
