require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'
Capybara.app = Url

feature 'URL Shortener' do
  background do
    Url::URL_REPOSITORY = UrlRepository.new
  end

  scenario 'User goes to homepage' do
    visit '/'
    expect(page).to have_field('url')
    expect(page).to have_button('Shorten')
  end

  scenario 'User can shorten a URL' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    click_on('Shorten')
    expect(page).to have_content("http://gschool.it")
    expect(page).to have_content("www.example.com/1")
    visit '/'
    fill_in('url', :with => "http://hello.it")
    click_on('Shorten')
    expect(page).to have_content("http://hello.it")
    expect(page).to have_content("www.example.com/2")
  end

  scenario 'User can visit shortened URL' do
    visit '/'
    fill_in('url', :with => "http://google.com")
    click_on('Shorten')
    visit '/1'
    expect(page.current_url).to eq('http://google.com/')
  end

  scenario 'User enters a string that is not a URL' do
    visit '/'
    fill_in('url', :with => "google")
    click_on('Shorten')
    expect(page).to have_content('google is not a valid URL')
  end

  scenario 'User doesnt enter anything into the url shortener field' do
    visit '/'
    fill_in('url', :with => "   ")
    click_on('Shorten')
    expect(page).to have_content('URL cannot be blank')
  end

  scenario 'User can navigate back to the homepage after shortening a URL' do
    visit '/'
    fill_in('url', :with => "http://google.com")
    click_on('Shorten')
    click_on('Shorten another link')
    expect(page).to have_field('url')
    expect(page).to have_button('Shorten')
  end

  scenario 'User can see stats of how many URLS shortened' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    click_on('Shorten')
    expect(page).to have_content("http://gschool.it")
    expect(page).to have_content("www.example.com/1")
    visit '/1'
    visit '/1'
    visit '/1'
    visit '/1'
    visit '/1'
    visit '/1?stats=true'
    expect(page).to have_content("http://www.example.com/1 has been visited 5 times.")
  end

end