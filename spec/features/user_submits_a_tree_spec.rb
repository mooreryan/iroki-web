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

  let(:auto_color_map) {
    File.join test_files, "auto_color.color_map" }
  let(:auto_color_tre) {
    File.join test_files, "auto_color.tre" }
  let(:auto_color_nex) {
    File.join test_files, "auto_color.nex" }

  let(:empty_name_map) {
    File.join test_files, "empty.name_map" }

  let(:two_group_biom) { File.join test_files, "two_group.biom" }
  let(:two_group_tre) { File.join test_files, "two_group.tre" }
  let(:two_group_nex) { File.join test_files, "two_group.nex" }


  context "good input" do
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

    scenario "they want kelly auto colors mixed with specified colors" do
      visit root_path

      attach_file :newick_file, auto_color_tre
      attach_file :color_map, auto_color_map
      check :color_labels
      check :color_branches
      check :exact

      click_button "Submit"

      expect_the_downloaded_nexus_file_to_be auto_color_nex
    end
  end

  context "with bad input it doesn't blow up" do
    # need to update this in iroki library
    it "actually gives good error messages"

    scenario "they click submit with out doing anything" do
      visit root_path

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "they only supply the newick file" do
      visit root_path

      attach_file :newick_file, basic_tre

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "they upload a tree and color map with no coloring options" do
      visit root_path

      attach_file :newick_file, basic_tre
      attach_file :color_map, basic_color_map_regex

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when only the newick file is given" do
      visit root_path

      attach_file :newick_file, basic_tre

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when only the color map file is given" do
      visit root_path

      attach_file :color_map, basic_color_map_with_tags

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when only the name map file is given" do
      visit root_path

      attach_file :name_map, empty_name_map

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when only the biom file is given" do
      visit root_path

      attach_file :biom_file, two_group_biom

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when given newick, color branches and neither biom nor color map" do
      visit root_path

      attach_file :newick_file, basic_tre
      check :color_branches

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when given newick, color labels and neither biom nor color map" do
      visit root_path

      attach_file :newick_file, basic_tre
      check :color_labels

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when given biom file but no color options" do
      visit root_path

      attach_file :biom_file, two_group_biom

      click_button "Submit"

      expect_to_see_the_error_page
    end

    scenario "when given --single-color with no biom file"

    scenario "when given --single-color with two group biom file"
  end
end
# see http://collectiveidea.com/blog/archives/2012/01/27/testing-file-downloads-with-capybara-and-chromedriver/
def expect_the_downloaded_nexus_file_to_be content
  expect(page.response_headers["Content-Disposition"]).
    to have_content "attachment"

  expect(page.source).to eq File.open(content).read
end

def expect_to_see_the_error_page
  expect(page).to have_css "h1", text: "Error"
end
