module Api
  module V1
    class CoursesController < BaseController
      before_action :set_course, only: %i[show update destroy]

      def index
        render json: Course.all
      end

      def show
        render json: @course
      end

      def create
        course = current_user.courses.new(course_params)
        if course.save
          render json: course, status: :created
        else
          render_errors(course)
        end
      end

      def update
        authorize_owner!(@course)
        return if performed?

        if @course.update(course_params)
          render json: @course
        else
          render_errors(@course)
        end
      end

      def destroy
        authorize_owner!(@course)
        return if performed?

        @course.destroy
        head :no_content
      end

      private

      def set_course
        @course = Course.find(params[:id])
      end

      def course_params
        params.require(:course).permit(:title, :description)
      end
    end
  end
end
