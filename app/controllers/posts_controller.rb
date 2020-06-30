class PostsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def search

    query = params[:search_posts].presence && params[:search_posts][:query]
    if query.present?
      @posts = Post.search_published(query)
    else
      @posts = Post.all
    end
  end
end
