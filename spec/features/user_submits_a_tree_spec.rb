require 'rails_helper'

feature 'User submits a tree' do
  scenario 'they see the home page' do
    tree = "(A:0.1,B:0.2,(C:0.3,D:0.4):0.5);"
    visit root_path

    fill_in 'Newick', with: tree
    click_button 'Submit'

    expect(page).to have_content tree
  end
end
