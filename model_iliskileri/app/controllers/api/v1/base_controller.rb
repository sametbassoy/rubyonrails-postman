module Api
  module V1
    class BaseController < ApplicationController
      private

      def render_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
