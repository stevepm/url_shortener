require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'
Capybara.app = Url

feature 'URL Shortener' do
  background do
    URLS_ARRAY = []
  end

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
    expect(page).to have_content("www.example.com/1")
    visit '/'
    fill_in('url', :with => "hello.it")
    click_on('Shorten')
    expect(page).to have_content("hello.it")
    expect(page).to have_content("www.example.com/2")
  end

  scenario 'User can visit shortened URL' do
    visit '/'
    fill_in('url', :with => "google.com")
    click_on('Shorten')
    visit '/3'
    expect(page.current_url).to eq('http://google.com/')
  end

end