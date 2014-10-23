MAILER_ADDRESS = "no-reply@fotbalek.herokuapp.com"

ROOT_ACCOUNT_USERNAME = "admin"
ROOT_ACCOUNT_EMAIL = "admin@fotbalek.herokuapp.com"
ROOT_ACCOUNT_PASSWORD = "root"

GAME_TYPE_SINGLE = 0;
GAME_TYPE_DOUBLE = 1;
GAME_TYPE_TWO_BALL = 2;
GAME_TYPE_FOURS = 3;

GAME_TYPE_STR = Array.new
GAME_TYPE_STR[GAME_TYPE_SINGLE] = "messages.base.game_type_single"
GAME_TYPE_STR[GAME_TYPE_DOUBLE] = "messages.base.game_type_double"
GAME_TYPE_STR[GAME_TYPE_TWO_BALL] = "messages.base.game_type_two_ball"
GAME_TYPE_STR[GAME_TYPE_FOURS] = "messages.base.game_type_fours"

GAME_PLAYERS_COUNT = Array.new
GAME_PLAYERS_COUNT[GAME_TYPE_SINGLE] = 1
GAME_PLAYERS_COUNT[GAME_TYPE_DOUBLE] = 2
GAME_PLAYERS_COUNT[GAME_TYPE_TWO_BALL] = 2
GAME_PLAYERS_COUNT[GAME_TYPE_FOURS] = 4

PLAYER_POSITION_DEFENSE = 1;
PLAYER_POSITION_ATTACK = 2;
PLAYER_POSITION_TICK_1 = 4;
PLAYER_POSITION_TICK_2 = 8;
PLAYER_POSITION_TICK_5 = 16;
PLAYER_POSITION_TICK_3 = 32;

TEAM_HOME = 0;
TEAM_AWAY = 1;

ATTENDANCE_PRIORITY_MIN = 0
ATTENDANCE_PRIORITY_MAX = 5

ERROR_PAGE = "/home/error"

DEFAULT_IMAGES = {
  :team_logo => {
    # no default logos for teams
  }
}