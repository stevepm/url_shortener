require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'
Capybara.app = Url

feature 'URL Shortener' do
  background do
    Url::URL_REPOSITORY = UrlRepository.new
    Url::settings.vanity_url = nil
    Url::settings.original_url = nil
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

  scenario 'User can see stats of the URL shortened' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    click_on('Shorten')
    5.times { visit '/1' }
    visit '/1?stats=true'
    expect(page).to have_content("http://www.example.com/1 has been visited 5 times.")
  end

  scenario 'User can enter a vanity URL' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "Steve")
    click_on('Shorten')
    expect(page).to have_content("http://gschool.it")
    expect(page).to have_content("www.example.com/Steve")
  end

  scenario 'User gets an error for duplicate URLs' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "gschool")
    click_on('Shorten')
    click_on('Shorten another link')
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "gschool")
    click_on('Shorten')
    expect(page).to have_content("gschool is already taken")
  end

  scenario 'User gets an error when trying to add profanity to a vanity URL' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "fuck")
    click_on('Shorten')
    expect(page).to have_content("Profanity is not allowed")
  end

  scenario 'User gets an error when they try to post a vanity URL greater than 12 characters' do
    visit '/'
    expect(page).to have_content("Maximum 12 characters")
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "morethantwelve")
    click_on('Shorten')
    expect(page).to have_content("Vanity URL must be 12 characters or shorter")
  end

  scenario 'User tries to add a vanity url with numbers in it' do
    visit '/'
    fill_in('url', :with => "http://gschool.it")
    fill_in('vanity', :with => "morethan12")
    click_on('Shorten')
    expect(page).to have_content("Vanity URL cannot contain numbers")
  end
end