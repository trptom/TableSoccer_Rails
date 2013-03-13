require 'test_helper'

class GamePlayersControllerTest < ActionController::TestCase
  setup do
    @game_player = game_players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_player" do
    assert_difference('GamePlayer.count') do
      post :create, game_player: { position: @game_player.position, team: @game_player.team }
    end

    assert_redirected_to game_player_path(assigns(:game_player))
  end

  test "should show game_player" do
    get :show, id: @game_player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_player
    assert_response :success
  end

  test "should update game_player" do
    put :update, id: @game_player, game_player: { position: @game_player.position, team: @game_player.team }
    assert_redirected_to game_player_path(assigns(:game_player))
  end

  test "should destroy game_player" do
    assert_difference('GamePlayer.count', -1) do
      delete :destroy, id: @game_player
    end

    assert_redirected_to game_players_path
  end
end
