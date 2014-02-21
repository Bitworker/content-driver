class SearchController < ApplicationController
  def index
    
  end
  
  def result
    @sites = params[:sites]
  end
end
