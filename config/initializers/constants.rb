# coding:utf-8

APPLICATION_TITLE = "Malík Urvi - foosball web"
APPLICATION_HEADER = "Malík Urvi"

WEB_URL = "http://fotbalek.herokuapp.com"

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

DEFAULT_IMAGES = {
  :team_logo => {
    # no default logos for teams
  }
}

# How many black dots is needed for one beer
BLACK_DOTS_GROUPING = 3
BLACK_DOT_REASONS_COUNT = 4

# Max number of days for reminder
REMINDER_MAX_DAYS = 50
# Max number of days for attendance overview mailing
OVERVIEW_MAX_DAYS = 50

# Currency for counting money
CURRENCY = "czk"