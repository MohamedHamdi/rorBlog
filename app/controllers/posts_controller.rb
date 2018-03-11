class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = @post.comments.build
    @comments = @post.comments
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    if user_signed_in?
      unless @post.user === current_user
        flash_message = "Only the owner can edit the Post."
        flash[:alert] = flash_message
        render :show
    end
    else
      flash_message = "You need to sign in before continue."
      flash[:alert] = flash_message
      redirect_to new_user_session_path
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
    if @post.persisted?
      flash[:success] = "Post has been created"
      redirect_to posts_path
    else
      flash.now[:danger] = "Post has not been created"
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    unless @post.user === current_user
      flash_message = "Only the owner can edit the post."
      flash[:alert] = flash_message
      redirect_to posts_index_path
    else
      if @post.update(post_params)
        flash[:success] = "post has been updated"
        redirect_to post_path(@post)
      else
        flash.now[:danger] = "post has not been updated"
        render :edit
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    unless @post.user === current_user
      flash_message = "You can not delete the Post."
      flash[:alert] = flash_message
      redirect_to @post
    else
      if @post.destroy
        flash[:success] = "Post has been deleted"
        redirect_to posts_path
      end
    end
  end

  private

    def resource_not_found
      message = "The Post you are looking for could not be found"
      flash[:danger] = message
      redirect_to root_path
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
