require 'test_helper'

class LeagueTeamsControllerTest < ActionController::TestCase
  setup do
    @league_team = league_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:league_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create league_team" do
    assert_difference('LeagueTeam.count') do
      post :create, league_team: { season: @league_team.season }
    end

    assert_redirected_to league_team_path(assigns(:league_team))
  end

  test "should show league_team" do
    get :show, id: @league_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @league_team
    assert_response :success
  end

  test "should update league_team" do
    put :update, id: @league_team, league_team: { season: @league_team.season }
    assert_redirected_to league_team_path(assigns(:league_team))
  end

  test "should destroy league_team" do
    assert_difference('LeagueTeam.count', -1) do
      delete :destroy, id: @league_team
    end

    assert_redirected_to league_teams_path
  end
end
