module Api
  module V1
    class VideosController < BaseController
      before_action :set_video, only: %i[show update destroy]

      def index
        render json: Video.includes(:course, :user)
      end

      def show
        render json: @video
      end

      def create
        video = current_user.videos.new(video_params)
        if video.save
          render json: video, status: :created
        else
          render_errors(video)
        end
      end

      def update
        authorize_owner!(@video)
        return if performed?

        if @video.update(video_params)
          render json: @video
        else
          render_errors(@video)
        end
      end

      def destroy
        authorize_owner!(@video)
        return if performed?

        @video.destroy
        head :no_content
      end

      private

      def set_video
        @video = Video.find(params[:id])
      end

      def video_params
        params.require(:video).permit(:title, :url, :description, :course_id)
      end
    end
  end
end
