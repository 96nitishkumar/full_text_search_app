class ArticlesController < ApplicationController
  # GET /articles or /articles.json
  def index
    if params[:query].present?
      @articles = Article.search(params[:query])
    else
      @articles = Article.all
    end
  end
end
