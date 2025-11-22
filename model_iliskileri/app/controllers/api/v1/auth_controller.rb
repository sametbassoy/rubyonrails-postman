module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: %i[signup login]

      def signup
        user = User.new(user_params)
        if user.save
          render json: auth_payload(user), status: :created
        else
          render_errors(user)
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          render json: auth_payload(user)
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def verify
        render json: { user: sanitize_user(current_user) }
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def auth_payload(user)
        {
          token: issue_token(user),
          user: sanitize_user(user)
        }
      end
    end
  end
end
