class BlogPostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
      case params[:scope]
      when 'published'
        @blog_posts = apply_filter(BlogPost.published.sorted)
      when 'scheduled'
        @blog_posts = BlogPost.scheduled.sorted if user_signed_in?
      when 'draft'
        @blog_posts = BlogPost.draft.sorted if user_signed_in?
      else
        @blog_posts = user_signed_in? ? apply_filter(BlogPost.sorted) : apply_filter(BlogPost.published.sorted)
      end
  
      @pagy, @blog_posts = pagy(@blog_posts)
          rescue Pagy::OverflowError
          redirect_to root_path(page: 1)
  end

  def show
      @blog_post = BlogPost.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end

  def new
      @blog_post = BlogPost.new
  end
  def create
      @blog_post = BlogPost.new(blog_post_params)
      if @blog_post.save
          redirect_to @blog_post
      else
          render :new, status: :unprocessable_entity
      end
  end

  def edit
      @blog_post = BlogPost.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end
  def update
      @blog_post = BlogPost.find(params[:id])
      if @blog_post.update(blog_post_params)
          redirect_to @blog_post
      else
          render :edit, status: :unprocessable_entity
      end
  end

  def destroy
      @blog_post = BlogPost.find(params[:id])
      @blog_post.destroy
      redirect_to root_path
  end

  def home
  end



  private
  def blog_post_params
      params.required(:blog_post).permit(:title, :content, :cover_image, :published_at)
  end

  def set_blog_post
      @blog_post = user_signed_in? ? BlogPost.find(params[:id]) : BlogPost.published.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end
  def apply_filter(blog_posts)
      case params[:filter]
      when 'last_1_day'
        blog_posts.where('created_at >= ?', 1.day.ago)
      when 'last_month'
        blog_posts.where('created_at >= ?', 1.month.ago)
      when 'last_year'
        blog_posts.where('created_at >= ?', 1.year.ago)
      else
        blog_posts
      end
    end
end