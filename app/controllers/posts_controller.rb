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
      # @posts = Post.search_published(query)
      @posts = Post.search_fuzzy(query)
      p "lista de posts"
      p @posts.records
    else
      @posts = Post.all
    end
  end
end
