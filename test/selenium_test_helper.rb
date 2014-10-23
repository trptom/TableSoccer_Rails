# coding:utf-8

require 'test_helper'

require 'capybara/rspec'

# trida pro integracni testy (vyuziva gem capybara s driverem selenium)
class ActionDispatch::IntegrationTest
  @loggenIn = false

  fixtures :all
  include Capybara::DSL

  def assert_uri(uri)
    current = URI.parse(current_url)
    "#{current.path}?#{current.query}".should == uri
  end

  def login (atts = nil)
    username = atts && atts[:username] ? atts[:username] : "admin"
    password = atts && atts[:password] ? atts[:password] : "root"
    default_page = atts && atts[:page] ? atts[:page] : "/"

    visit default_page
    click_on 'Přihlásit'
    fill_in "username", :with => username
    fill_in "password", :with => password
    click_on 'Přihlásit se'

    assert_equal default_page, current_path
    assert page.has_content?(username)
  end

  def logout
    click_on 'Odhlásit'
  end

  def setup
    page.driver.browser.manage.window.maximize
  end

  def teardown
    if page.has_content?('Odhlásit')
      logout
    end
  end
end