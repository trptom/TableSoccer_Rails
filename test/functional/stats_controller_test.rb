require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get players" do
    get :players
    assert_response :success
  end

  test "should get player" do
    get :player
    assert_response :success
  end

  test "should get team" do
    get :team
    assert_response :success
  end

end
