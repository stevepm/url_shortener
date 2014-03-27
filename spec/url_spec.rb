require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'
Capybara.app = Url

feature 'URL Shortener' do
  scenario 'User goes to homepage' do
    visit '/'
    expect(page).to have_field('url', :with => "Enter the URL you would like to 'shorten'")
    expect(page).to have_button('Shorten')
  end

end