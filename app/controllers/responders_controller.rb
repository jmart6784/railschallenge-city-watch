class RespondersController < ApplicationController
  def index
    if params[:show] === "capacity"
      render json: {
        capacity: {
          Fire: get_capacity("Fire"),
          Police: get_capacity("Police"),
          Medical: get_capacity("Medical") 
        }
      }, status: 200
    elsif (
      params[:show].downcase === "fire" || 
      params[:show].downcase === "police" || 
      params[:show].downcase === "medical"
    )
      responders = Responder.where(type: params[:show])
      render json: responders, status: 200
    elsif params[:show] === "total_capacity"
      render json: {
        Fire: Responder.where(type: "Fire").sum(:capacity),
        Police: Responder.where(type: "Police").sum(:capacity),
        Medical: Responder.where(type: "Medical").sum(:capacity)
      }, status: 200
    elsif params[:show] === "total_on_duty"
      render json: {
        Fire: Responder.where(type: "Fire", on_duty: true).sum(:capacity),
        Police: Responder.where(type: "Police", on_duty: true).sum(:capacity),
        Medical: Responder.where(type: "Medical", on_duty: true).sum(:capacity)
      }, status: 200
    else
      responders = Responder.all

      render json: responders, status: 200
    end
  end

  def show
    if responder
      render json: responder
    else
      render json: { :message => "responder doesn't exist" }, status: 404
    end
  end

  def create
    if forbidden_param?("create") || !responder_params[:emergency_code].nil?
      unpermitted_param_response("create")
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

  def get_capacity(department)
    department_capacity = []

    Responder.where(type: department, on_duty: true).each do |responder|
      next unless responder.emergency_code.nil?
      department_capacity << responder.capacity
    end

    department_capacity << 0 if department_capacity.length === 0

    return department_capacity
  end

  def forbidden_param?(action)
    if action === "create"
      true if (
        responder_params[:emergency_code] || 
        responder_params[:id] || 
        responder_params[:on_duty]
      )
    elsif action === "update"
      true if (
        responder_params[:emergency_code] || 
        responder_params[:id] || 
        responder_params[:type] ||
        responder_params[:name] || 
        responder_params[:capacity]
      )
    end
  end

  def unpermitted_param_response(action)
    if action === "create"
      if responder_params[:emergency_code]
        render json: { :message => 'found unpermitted parameter: emergency_code' }, status: 422
      elsif responder_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      elsif responder_params[:on_duty]
        render json: { :message => 'found unpermitted parameter: on_duty' }, status: 422
      end   
    elsif action === "update"
      if responder_params[:emergency_code]
        render json: { :message => 'found unpermitted parameter: emergency_code' }, status: 422
      elsif responder_params[:id]
        render json: { :message => 'found unpermitted parameter: id' }, status: 422
      elsif responder_params[:type]
        render json: { :message => 'found unpermitted parameter: type' }, status: 422
      elsif responder_params[:name]
        render json: { :message => 'found unpermitted parameter: name' }, status: 422
      elsif responder_params[:capacity]
        render json: { :message => 'found unpermitted parameter: capacity' }, status: 422
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