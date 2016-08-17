class IrokiJob < ActiveJob::Base
  queue_as :default

  def perform(color_branches: nil,
              color_taxa_names: nil,
              exact: nil,
              remove_bootstraps_below: nil,
              color_map_f: nil,
              biom_f: nil,
              single_color: nil,
              name_map_f: nil,
              auto_color: nil,
              display_auto_color_options: nil,
              newick_f: nil,
              out_f: nil)

    # sleep 7

    Iroki::Main::main(color_branches: color_branches,
                      color_taxa_names: color_taxa_names,
                      exact: exact,
                      remove_bootstraps_below: remove_bootstraps_below,
                      color_map_f: color_map_f,
                      biom_f: biom_f,
                      single_color: single_color,
                      name_map_f: name_map_f,
                      auto_color: auto_color,
                      display_auto_color_options: display_auto_color_options,
                      newick_f: newick_f,
                      out_f: out_f)
  end
end
