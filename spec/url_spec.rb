require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'
Capybara.app = Url

feature 'URL Shortener' do
  scenario 'User goes to homepage' do
    visit '/'
    expect(page).to have_field('url')
    expect(page).to have_button('Shorten')
  end

  scenario 'User can shorten a URL' do
    visit '/'
    fill_in('url', :with => "gschool.it")
    click_on('Shorten')
    expect(page).to have_content("gschool.it")
    expect(page).to have_content("http://serene-atoll-7447.herokuapp.com/1")
    visit '/'
    fill_in('url', :with => "hello.it")
    click_on('Shorten')
    expect(page).to have_content("hello.it")
    expect(page).to have_content("http://serene-atoll-7447.herokuapp.com/2")
  end

end