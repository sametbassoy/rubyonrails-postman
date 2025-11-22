module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: %i[show update destroy]

      def index
        users = User.all
        render json: users.map { |user| sanitize_user(user) }
      end

      def show
        render json: sanitize_user(@user)
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: sanitize_user(user), status: :created
        else
          render_errors(user)
        end
      end

      def update
        if @user.update(user_params)
          render json: sanitize_user(@user)
        else
          render_errors(@user)
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
