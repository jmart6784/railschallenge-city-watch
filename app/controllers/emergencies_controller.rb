class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all

    resolved = 0
    emergencies.each { |emergency|  resolved += 1 if !emergency.resolved_at.nil? }

    render json: {emergencies: emergencies, full_response: [resolved, emergencies.count]}, status: 200
  end

  def show
    if emergency
      render json: emergency
    else
      render json: { :message => "emergency doesn't exist" }, status: 404
    end
  end

  def create
    if forbidden_param?("create")
      unpermitted_param_response("create")
    else
      emergency = Emergency.new(emergency_params)

      if emergency.save
        unless (
          emergency.fire_severity === 0 && 
          emergency.police_severity === 0 && 
          emergency.medical_severity === 0
        )
          fire_info = allocate_responders(emergency, "Fire")
          police_info = allocate_responders(emergency, "Police")
          medical_info = allocate_responders(emergency, "Medical")
    
          all_responders = fire_info[:responders] + police_info[:responders] + medical_info[:responders]
    
          full_response = true if (
            fire_info[:full_response] && 
            police_info[:full_response] && 
            medical_info[:full_response]
          )

          render json: {
            emergency: emergency, 
            responders: all_responders,
            full_response: full_response
          }, status: 201
        else
          render json: {
            emergency: emergency, 
            responders: [],
            full_response: true
          }, status: 201
        end
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

  def new
    render json: { :message => 'page not found' }, status: 404
  end

  def edit
    render json: { :message => 'page not found' }, status: 404
  end

  def destroy
    render json: { :message => 'page not found' }, status: 404
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
        emergency_params[:id] || 
        emergency_params[:code]
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
      elsif emergency_params[:code]
        render json: { :message => 'found unpermitted parameter: code' }, status: 422
      end      
    end
  end

  def allocate_responders(emergency, department)
    department_response = Responder.where(
      type: department, 
      on_duty: true, 
      capacity: emergency["#{department.downcase}_severity"]
    ).limit(1)

    if department_response[0].nil?
      department_response = []
      department_units = 0

      Responder.where(type: department, on_duty: true).each do |responder|
        responder[:emergency_code] = emergency[:code]
        responder.save
        if department_units >= emergency["#{department.downcase}_severity"]
          department_units += responder.capacity
          department_response << responder
          break
        else
          department_units += responder.capacity
          department_response << responder
        end
      end
    else
      department_units = department_response[0].capacity
      department_response[0][:emergency_code] = emergency[:code]
      department_response[0].save
    end

    full_response = false

    full_response = true if department_units >= emergency["#{department.downcase}_severity"]

    return {responders: department_response, full_response: full_response}
  end

  def emergency
    @emergency ||= Emergency.find_by(code: params[:code])
  end

  def emergency_params
    params.require(:emergency).permit(:id, :code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
  end
end
