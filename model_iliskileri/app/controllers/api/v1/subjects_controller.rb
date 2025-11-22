module Api
  module V1
    class SubjectsController < BaseController
      before_action :set_subject, only: %i[show update destroy]

      def index
        render json: Subject.all
      end

      def show
        render json: @subject
      end

      def create
        subject = Subject.new(subject_params)
        if subject.save
          render json: subject, status: :created
        else
          render_errors(subject)
        end
      end

      def update
        if @subject.update(subject_params)
          render json: @subject
        else
          render_errors(@subject)
        end
      end

      def destroy
        @subject.destroy
        head :no_content
      end

      private

      def set_subject
        @subject = Subject.find(params[:id])
      end

      def subject_params
        params.require(:subject).permit(:name, :description)
      end
    end
  end
end
