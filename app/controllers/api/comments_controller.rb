class Api::CommentsController < Api::ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    render json: @comments, status: :ok
  end

  def create
    request_body = JSON.parse(request.body.read)
    @comment = Comment.new(text: request_body['comment'])
    @comment.author = User.find_by(id: params[:user_id])
    @comment.posts = Post.find(params[:post_id])

    if @comment.save
      render json: { message: 'Comment was created successfully', comment: @comment }, status: :created
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end
end
