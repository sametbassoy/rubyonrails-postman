module Api
  module V1
    class PostsController < BaseController
      before_action :set_post, only: %i[show update destroy]

      def index
        posts = Post.includes(:user, :subject, :course)
        render json: posts.as_json(include: %i[user subject course])
      end

      def show
        render json: @post.as_json(include: %i[user subject course comments analyses])
      end

      def create
        post = current_user.posts.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render_errors(post)
        end
      end

      def update
        authorize_owner!(@post)
        return if performed?

        if @post.update(post_params)
          render json: @post
        else
          render_errors(@post)
        end
      end

      def destroy
        authorize_owner!(@post)
        return if performed?

        @post.destroy
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content, :subject_id, :course_id)
      end
    end
  end
end
