require 'rails_helper'

RSpec.describe IrokiJob, type: :job do
  let(:test_files) { File.join File.dirname(__FILE__), "..", "features", "test_files" }

  let(:color_map_override_biom) {
    File.join test_files, "color_map_override.biom" }
  let(:color_map_override_tre) {
    File.join test_files, "color_map_override.tre" }
  let(:color_map_override_nex) {
    File.join test_files, "color_map_override.nex" }
  let(:color_map_override_color_map) {
    File.join test_files, "color_map_override.color_map" }
  let(:color_map_override_name_map) {
    File.join test_files, "color_map_override.name_map" }
  let(:output_nexus) { File.join test_files, "output.nex" }

  it "runs the Iroki main method" do
    val = IrokiJob.perform_now color_branches:   true,
                               color_taxa_names: true,
                               exact:            true,
                               name_map_f:       color_map_override_name_map,
                               color_map_f:      color_map_override_color_map,
                               biom_f:           color_map_override_biom,
                               newick_f:         color_map_override_tre,
                               out_f:            output_nexus

    expect(val).to eq :success
  end

  # TODO use this to test the controller
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect { IrokiJob.perform_later }.to have_enqueued_job IrokiJob
  end
end
