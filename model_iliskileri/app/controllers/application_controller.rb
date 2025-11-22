class ApplicationController < ActionController::API
  before_action :authenticate_request

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  attr_reader :current_user

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    return render_unauthorized unless token

    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded['sub'])
  rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_unauthorized
    render json: { error: 'Unauthorized or invalid token' }, status: :unauthorized
  end

  def render_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_forbidden
    render json: { error: 'You are not allowed to perform this action' }, status: :forbidden
  end

  def sanitize_user(user)
    user.as_json(except: [:password_digest])
  end

  def authorize_owner!(resource)
    return unless resource.respond_to?(:user_id)

    render_forbidden unless resource.user_id == current_user.id
  end

  def issue_token(user)
    JsonWebToken.encode({ sub: user.id })
  end
end
