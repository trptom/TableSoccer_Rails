# coding:utf-8

require 'selenium_test_helper'

class AdminUsersFlowTest < ActionDispatch::IntegrationTest
  test "show list" do
    login

    click_on "Admin zóna"
    click_on "Uživatelé"

    assert_equal users_path, current_path

    logout
  end
  
  test "show list with authorized not root user" do
    login :username => "trptom", :password => "password"

    click_on "Admin zóna"
    click_on "Uživatelé"

    assert_equal users_path, current_path

    logout
  end
end
