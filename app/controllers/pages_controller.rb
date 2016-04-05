class PagesController < ApplicationController
  def home
    @newick = params[:newick] if params[:newick]
    @color_map = params[:color_map] if params[:color_map]
    @name_map = params[:name_map] if params[:name_map]

  end

  def about
  end

  def contact
  end
end
