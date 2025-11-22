module Api
  module V1
    class AnalysesController < BaseController
      before_action :set_analysis, only: %i[show update destroy]

      def index
        analyses = Analysis.includes(:user, :post)
        render json: analyses.as_json(include: %i[user post])
      end

      def show
        render json: @analysis.as_json(include: %i[user post])
      end

      def create
        analysis = current_user.analyses.new(analysis_params)
        if analysis.save
          render json: analysis, status: :created
        else
          render_errors(analysis)
        end
      end

      def update
        authorize_owner!(@analysis)
        return if performed?

        if @analysis.update(analysis_params)
          render json: @analysis
        else
          render_errors(@analysis)
        end
      end

      def destroy
        authorize_owner!(@analysis)
        return if performed?

        @analysis.destroy
        head :no_content
      end

      private

      def set_analysis
        @analysis = Analysis.find(params[:id])
      end

      def analysis_params
        params.require(:analysis).permit(:title, :content, :post_id)
      end
    end
  end
end
