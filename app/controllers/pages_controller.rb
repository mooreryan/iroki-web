class PagesController < ApplicationController
  def home
    @color_map_title = "Color the tree with an explicit color map file."
  end

  def submit
    @newick           = params[:newick_file]
    @color_map        = params[:color_map]
    @name_map         = params[:name_map]
    @biom_file        = params[:biom_file]
    @color_branches   = params[:color_branches]
    @color_labels     = params[:color_labels]
    @exact            = params[:exact]
    @remove_below     = params[:remove_below]
    @single_color     = params[:single_color]
    @auto_color       = params[:auto_color]

    if @newick
      basein = File.basename(@newick.original_filename,
                             File.extname(@newick.original_filename))
    else
      basein = "apple"
    end

    newick_path    = @newick.tempfile.path if @newick
    color_map_path = @color_map.tempfile.path if @color_map
    name_map_path  = @name_map.tempfile.path if @name_map
    biom_file_path = @biom_file.tempfile.path if @biom_file

    outf =
      Tempfile.new ["#{basein}.", ".nex"]

    begin
      flash.now[:notice] = "Processing #{newick_path}"

      # Iroki::Main::main(color_branches: @color_branches,
      #                   color_taxa_names: @color_labels,
      #                   exact: @exact,
      #                   remove_bootstraps_below: @remove_below.to_f,
      #                   color_map_f: color_map_path,
      #                   biom_f: biom_file_path,
      #                   single_color: @single_color,
      #                   name_map_f: name_map_path,
      #                   auto_color: @auto_color,
      #                   display_auto_color_options: nil,
      #                   newick_f: newick_path,
      #                   out_f: outf.path)

      IrokiJob.perform_later(color_branches: @color_branches,
                             color_taxa_names: @color_labels,
                             exact: @exact,
                             remove_bootstraps_below: @remove_below.to_f,
                             color_map_f: color_map_path,
                             biom_f: biom_file_path,
                             single_color: @single_color,
                             name_map_f: name_map_path,
                             auto_color: @auto_color,
                             display_auto_color_options: nil,
                             newick_f: newick_path,
                             out_f: outf.path)

      send_file outf.path, type: "text"
      # redirect_to about_path
    rescue AbortIf::Exit => e
      @apple ||= e.message
      render :error
    end
  end

  def about
  end

  def contact
  end

  def error
  end

  def color
  end
end
