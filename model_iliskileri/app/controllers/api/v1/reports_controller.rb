module Api
  module V1
    class ReportsController < BaseController
      before_action :set_report, only: %i[show update destroy]

      def index
        reports = Report.includes(:user)
        render json: reports.as_json(include: :user)
      end

      def show
        render json: @report.as_json(include: :user)
      end

      def create
        report = current_user.reports.new(report_params)
        if report.save
          render json: report, status: :created
        else
          render_errors(report)
        end
      end

      def update
        authorize_owner!(@report)
        return if performed?

        if @report.update(report_params)
          render json: @report
        else
          render_errors(@report)
        end
      end

      def destroy
        authorize_owner!(@report)
        return if performed?

        @report.destroy
        head :no_content
      end

      private

      def set_report
        @report = Report.find(params[:id])
      end

      def report_params
        params.require(:report).permit(:title, :content)
      end
    end
  end
end
