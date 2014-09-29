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
  # test "the truth" do
  #   assert true
  # end
end
