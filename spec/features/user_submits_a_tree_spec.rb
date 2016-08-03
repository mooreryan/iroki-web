require 'rails_helper'

feature 'User submits a tree' do
  let(:test_files) { File.join File.dirname(__FILE__), "test_files" }
  let(:basic_tre) { File.join test_files, "basic.tre" }

  let(:basic_color_map_with_tags) {
    File.join test_files, "basic_color_map_with_tags.txt" }
  let(:basic_color_map_regex) {
    File.join test_files, "basic_color_map_regex.txt" }

  let(:basic_branches) {
    File.join test_files, "basic_branches_only.nex" }
  let(:basic_branches_regex) {
    File.join test_files, "basic_branches_only_regex.nex" }

  let(:basic_labels) {
    File.join test_files, "basic_labels_only.nex"}
  let(:basic_labels_regex) {
    File.join test_files, "basic_labels_only_regex.nex"}

  let(:basic_labels_and_branches) {
    File.join test_files, "basic_labels_and_branches.nex"}
  let(:basic_labels_and_branches_regex) {
    File.join test_files, "basic_labels_and_branches_regex.nex"}

  scenario "they want to color branches with exact matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_with_tags
    check :color_branches
    check :exact

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_branches
  end

  scenario "they want to color branches with regex matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_regex
    check :color_branches

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_branches_regex
  end

  scenario "they want to color labels with exact matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_with_tags
    check :color_labels
    check :exact

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_labels
  end

  scenario "they want to color labels with regex matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_regex
    check :color_labels

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_labels_regex
  end

  scenario "they want to color labels and branches with exact matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_with_tags
    check :color_labels
    check :color_branches
    check :exact

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_labels_and_branches
  end


  scenario "they want to color labels and branches with regex matching" do
    visit root_path

    attach_file :newick_file, basic_tre
    attach_file :color_map, basic_color_map_regex
    check :color_labels
    check :color_branches

    click_button "Submit"

    expect_the_downloaded_nexus_file_to_be basic_labels_and_branches_regex
  end
end

# see http://collectiveidea.com/blog/archives/2012/01/27/testing-file-downloads-with-capybara-and-chromedriver/
def expect_the_downloaded_nexus_file_to_be content
  expect(page.response_headers["Content-Disposition"]).
    to have_content "attachment"

  expect(page.source).to eq File.open(content).read
end
