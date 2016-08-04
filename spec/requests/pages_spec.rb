require 'rails_helper'

describe "pages", type: :feature do
  subject { page }

  shared_examples_for "all pages" do
    describe "title" do
      it { should have_title full_title page_title }
    end

    describe "nav bar" do
      it { should have_css ".top-bar > .top-bar-left > ul.menu" }
      it { should have_css ".top-bar > .top-bar-right > ul.menu" }
      it { should have_link "Iroki", href: root_path }
      it { should have_link "About", href: about_path }
      it { should have_link "Contact", href: contact_path }
      it { should have_link "Citation", href: citation_path }
    end
  end

  describe "home" do
    before { visit root_path }
    let(:page_title) { "" }

    it_should_behave_like "all pages"
    it { should_not have_title "| Iroki" }
  end

  describe "about" do
    before { visit about_path }
    let(:page_title) { "About" }

    it_should_behave_like "all pages"
  end

  describe "contact" do
    before { visit contact_path }
    let(:page_title) { "Contact" }

    it_should_behave_like "all pages"
  end

  describe "citation" do
    before { visit citation_path }
    let(:page_title) { "Citation" }

    it_should_behave_like "all pages"
  end
end
