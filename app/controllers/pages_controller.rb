class PagesController < ApplicationController
  def home
    if params[:newick] && params[:color_map] && params[:name_map]
      @newick = params[:newick]
      @color_map = params[:color_map]
      @name_map = params[:name_map]
      @color_branches = params[:color_branches]
      @color_taxa_names = params[:color_taxa_names]
      @exact = params[:exact]
      @remove_below = params[:remove_below]


      @newick_f = ApplicationHelper::upload params[:newick]
      @color_map_f = ApplicationHelper::upload params[:color_map]
      @name_map_f = ApplicationHelper::upload params[:name_map]

      @newick_contents = File.open(@newick_f).read
      @color_map_contents = File.open(@color_map_f).read
      @name_map_contents = File.open(@name_map_f).read


      time_now = Time.now.strftime("%Y%m%d%H%M%S%L")
      outf =
        Rails.root.join("public", "uploads", "haha.#{time_now}.nex")

      IrokiLib::Main::main(color_branches: @color_branches,
                           color_taxa_names: @color_taxa_names,
                           exact: @exact,
                           remove_bootstraps_below: @remove_below.to_f,
                           color_map_f: @color_map_f,
                           name_map_f: @name_map_f,
                           auto_color: nil,
                           display_auto_color_options: nil,
                           newick_f: @newick_f,
                           out_f: outf)

      @outf_contents = File.open(outf).read

      ApplicationHelper::remove_upload @newick_f
      ApplicationHelper::remove_upload @color_map_f
      ApplicationHelper::remove_upload @name_map_f
      ApplicationHelper::remove_upload outf

    end
  end

  def about
  end

  def contact
  end
end
