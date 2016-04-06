class PagesController < ApplicationController
  def home
  end

  def submit
    if params[:newick] && params[:color_map] && params[:name_map]
      @newick = params[:newick]
      @color_map = params[:color_map]
      @name_map = params[:name_map]
      @color_branches = params[:color_branches]
      @color_taxa_names = params[:color_taxa_names]
      @exact = params[:exact]
      @remove_below = params[:remove_below]

      basein = File.basename(@newick.original_filename,
                             File.extname(@newick.original_filename))

      outf =
        Tempfile.new ["#{basein}.", ".nex"]

      begin
        IrokiLib::Main::main(color_branches: @color_branches,
                             color_taxa_names: @color_taxa_names,
                             exact: @exact,
                             remove_bootstraps_below: @remove_below.to_f,
                             color_map_f: @color_map.tempfile.path,
                             name_map_f: @name_map.tempfile.path,
                             auto_color: nil,
                             display_auto_color_options: nil,
                             newick_f: @newick.tempfile.path,
                             out_f: outf.path)
        send_file outf.path, type: "text"
      rescue AbortIf::Exit => e
        @apple ||= e.message
      end
    end
  end

  def about
  end

  def contact
  end
end
