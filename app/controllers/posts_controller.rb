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
      # @posts = Post.search_fuzzy(query)
      # @posts = Post.search_highlight(query)
      @posts = Post.search_agregation(query)
      p "lista de posts"
      p @posts.records
      p "agregations"
      p @posts.aggregations.values[0].buckets
      p @posts.aggregations.values[0].buckets[0][:key]
      p "*************************************"
    else
      @posts = Post.all
    end
  end
end
