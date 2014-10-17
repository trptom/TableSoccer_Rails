require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create new" do
    @user = User.new
    @user.username = "123456789agvbdert"
    @user.email = "123456789agvbdert@fafdafasdfdas.cz"
    @user.password = "abcd"
    @user.password_confirmation = "abcd"

    assert @user.save
  end
  
  test "activate" do
    @user = User.new
    @user.username = "123456789agvbdert"
    @user.email = "123456789agvbdert@fafdafasdfdas.cz"
    @user.password = "abcd"
    @user.password_confirmation = "abcd"
    @user.save
    
    assert @user.activate!
  end
  
  test "get_name" do
    @user = User.new
    @user.username = "123456789agvbdert"
    @user.email = "123456789agvbdert@fafdafasdfdas.cz"
    @user.password = "abcd"
    @user.password_confirmation = "abcd"
    @user.save
    
    assert @user.get_name == "123456789agvbdert"
    
    @user.name = "name"
    @user.save
    
    assert @user.get_name == "name"
    
    @user.name = ""
    @user.save
    
    assert @user.get_name == "123456789agvbdert"
  end
  
  test "has_team" do
    assert users(:trptom).has_team(teams(:one))
    assert users(:trptom).has_team(teams(:one).id)
    assert !(users(:trptom).has_team(teams(:two)))
    assert !(users(:trptom).has_team(teams(:two).id))
    assert !(users(:without_player).has_team(teams(:one)))
    assert !(users(:without_player).has_team(teams(:one).id))
    assert !(users(:with_player_without_team).has_team(teams(:one)))
    assert !(users(:with_player_without_team).has_team(teams(:one).id))
    assert !(users(:with_player_without_team).has_team("just some string rubbish"))
  end
  
  test "get_first_free_name" do
    assert_equal "free-name", User.get_first_free_name("free-name")
    assert_equal "trptom2", User.get_first_free_name("trptom")
  end
end
