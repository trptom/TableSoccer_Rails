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
    assert !users(:trptom).has_team(nil), "should return false when wrong team (not id or Team) presented"
    assert users(:trptom).has_team(teams(:mortal))
    assert users(:trptom).has_team(teams(:mortal).id)
    assert !(users(:trptom).has_team(teams(:kacenkaastrasidla)))
    assert !(users(:trptom).has_team(teams(:kacenkaastrasidla).id))
    assert !(users(:admin).has_team(teams(:mortal)))
    assert !(users(:admin).has_team(teams(:mortal).id))
    assert !(users(:offususer).has_team(teams(:mortal)))
    assert !(users(:offususer).has_team(teams(:mortal).id))
    assert !(users(:offususer).has_team("just some string rubbish"))
  end
  
  test "get_first_free_name" do
    assert_equal "free-name", User.get_first_free_name("free-name")
    assert_equal "trptom2", User.get_first_free_name("trptom")
  end
end
