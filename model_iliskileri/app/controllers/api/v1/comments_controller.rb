module Api
  module V1
    class CommentsController < BaseController
      before_action :set_comment, only: %i[show update destroy]

      def index
        comments = Comment.all
        render json: comments
      end

      def show
        render json: @comment
      end

      def create
        comment = current_user.comments.new(comment_params)
        if comment.save
          render json: comment, status: :created
        else
          render_errors(comment)
        end
      end

      def update
        authorize_owner!(@comment)
        return if performed?

        if @comment.update(comment_params)
          render json: @comment
        else
          render_errors(@comment)
        end
      end

      def destroy
        authorize_owner!(@comment)
        return if performed?

        @comment.destroy
        head :no_content
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content, :post_id)
      end
    end
  end
end
