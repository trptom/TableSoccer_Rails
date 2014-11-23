# coding:utf-8

include GamesHelper
include MatchesHelper

# Controller containing actions for creating/editing/viewing matches. You can
# also control possible addendance dates of matches and ad dnew games by them.
# 
# ==== See
# PossibleDate,
# Match,
# Game
class MatchesController < ApplicationController
  before_filter :require_admin, :except => [ :view ]
  before_filter :require_login, :only => [ :view ]
  
  # Shows list of Matches (for adimn), ordered by _start_date_.
  # 
  # ==== Format
  # * HTML
  def index
    @matches = Match.order(:start_date).all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # Shows detail of _Match_ (for admin).
  #
  # ==== Required params
  # _id_:: id of _Match_ that should be shown.
  #
  # ==== Format
  # * HTML
  def show
    @match = Match.find(params[:id])
    @current_time = DateTime.now
    @attendance_from = DateTime.new(
      @current_time.year,
      @current_time.month,
      @current_time.day,
      18, 00, 00
    )
    @attendance_until = DateTime.new(
      @current_time.year,
      @current_time.month,
      @current_time.day,
      23, 00, 00
    )

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # Shows form that serves to create new _Match_.
  #
  # ==== Format
  # * HTML
  def new
    @match = Match.new

    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.matches.form.back_to_list"), :url => matches_path, :html_options => {} }
        ]
      }
    end
  end

  # Shows form to edit the _Match_.
  #
  # ==== Required params
  # _id_:: id of _Match_ to be edited.
  #
  # ==== Format
  # * HTML
  def edit
    @match = Match.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.matches.form.back_to_detail"), :url => @match , :html_options => {} },
          { :body => I18n.t("messages.matches.form.back_to_list"), :url => matches_path, :html_options => {} }
        ]
      }
    end
  end

  # Creates new _Match_ based of params, sent from "new form".
  #
  # ==== Required params
  # _match_:: contains all attributes of _Match_ which should be created.
  #
  # ==== Format
  # * HTML
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: I18n.t('messages.matches.create.success') }
      else
        format.html {
          @errors = @match.errors
          render action: "new"
        }
      end
    end
  end

  # Updates _Match_ based of params, sent from "edit form".
  #
  # ==== Required params
  # _id_:: id of _Match_ to be updated.
  # _match_:: contains all attributes of _Match_ which should be updated.
  #
  # ==== Format
  # * HTML
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: I18n.t('messages.matches.update.success') }
      else
        format.html {
          @errors = @match.errors
          render action: "edit"
        }
      end
    end
  end

  # Deletes _Match_.
  #
  # ==== Required params
  # _id_:: id of _Match_ that should be deleted.
  #
  # ==== Format
  # * HTML
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    for game in @match.games
      game.destroy
    end

    respond_to do |format|
      format.html { redirect_to matches_url }
    end
  end

  # Adds _Game_ to the _Match_. _Game_ has default attributes and its
  # _game_number_ and _type_ are based on number of games, which are already
  # appended to _Match_ (_game_number_ is highest _game_number_ of current games
  # + 1).
  #
  # ==== Required params
  # _id_:: id of _Match_ to which _Game_ should be appended.
  #
  # ==== Format
  # * HTML
  def add_game
    @match = Match.find(params[:id])
    @game = Game.new
    @game.match = @match
    @game.game_number = @match.games.order(:game_number).last ? @match.games.last.game_number+1 : 1;

    @game.game_type = get_preferred_game_type({ :game => @game })
    # TODO asi to nema smysl - smazat
#    if (@game.game_number == 3)||
#        (@game.game_number == 4)||
#        (@game.game_number == 10)
#      @game.game_type = GAME_TYPE_SINGLE
#    end
#    if (@game.game_number == 1)||
#        (@game.game_number == 2)||
#        ((@game.game_number >= 6)&&(@game.game_number <= 9))||
#        (@game.game_number >= 11)
#      @game.game_type = GAME_TYPE_DOUBLE
#    end
#    if (@game.game_number == 5)
#      @game.game_type = GAME_TYPE_FOURS
#    end
    @game.save

    respond_to do |format|
      format.html { 
        redirect_to @match
      }
    end
  end

  # Adds all (10) Games to _Match_. By params, you can set default players and
  # type of 5th game.
  #
  # ==== Required params
  # _id_:: id of _Match_ to which Games should be appended.
  # _overwrite_existing_:: when true, all Games currently assigned to _Match_
  # are deleted.
  # _player_:: array of Players ("A", "B", "C", "D", "1", "2", "3", "4") which
  # should be set by default (to their corresponding positions) to all Games.
  # Not required. When not sent, all games are empty.
  # _game_ID_type_:: forcely overwrites _game_type_ of _Game_ with _ID_. There
  # params are not required. When not sent, gefault game types are used.
  #
  # ==== Format
  # * HTML  
  def add_all_games
    @match = Match.find(params[:id])
    @res = true

    if (params[:overwrite_existing])
      for game in @match.games
        game.destroy
      end
    end

    @games = Array.new
    for a in 1..10
      @games[a] = Game.new(
        :game_number => a,
        :match_id => @match.id,
        :game_type => GamesHelper::get_preferred_game_type({ :game_number => a }),
        :score_home => 0,
        :score_away => 0
      )
      
      if params["game_#{a}_type"]
        @games[a].game_type = params["game_#{a}_type"].to_i
      end

      @res = @games[a].save && @res
      
      if params[:player]
        @res = set_preferred_players(@games[a], params[:player]) && @res
      end
    end
    
    respond_to do |format|
      format.html { 
        if @res
          redirect_to @match, notice: I18n.t("messages.matches.add_all_games.success")
        else
          redirect_to @match, notice: I18n.t("messages.matches.add_all_games.error")
        end
      }
    end
  end
  
  # Adds new attendance's _PossibleDate_ to match.
  #
  # ==== Required params
  # _id_:: id of _Match_ to which _PossibleDate_ should be appended.
  # _start_:: DateTime of start of new _PossibleDate_.
  # _end_:: DateTime of end of new _PossibleDate_.
  #
  # ==== Format
  # * HTML
  def add_possible_date
    @date = PossibleDate.new(
      :start_time => params[:start],
      :end_time => params[:end],
      :match_id => params[:id]
    )
    @date.save
    
    respond_to do |format|
      @match = Match.find(params[:id])
      format.html {
        redirect_to @match
      }
    end
  end
  
  # Updates attendance's _PossibleDate_.
  #
  # ==== Required params
  # _id_:: id of _PossibleDate_ that should be appended.
  # _start_:: DateTime of new start.
  # _end_:: DateTime of new end.
  #
  # ==== Format
  # * HTML
  def update_possible_date
    @date = PossibleDate.find(params[:id])
    @date.start_time = params[:start]
    @date.end_time = params[:end]
    @date.save
    
    respond_to do |format|
      format.html {
        redirect_to @date.match
      }
    end
  end
  
  # Removes attendance's _PossibleDate_.
  #
  # ==== Required params
  # _id_:: id of _PossibleDate_ that should be removed.
  #
  # ==== Format
  # * HTML
  def remove_possible_date
    @date = PossibleDate.find(params[:id])
    @match = @date.match
    
    @date.destroy
    
    respond_to do |format|
      format.html {
        redirect_to @match
      }
    end
  end
  
  # Shows detail of _Match_ for non-admin users.
  #
  # ==== Required params
  # _id_:: id of _Match_ which detail should be shown.
  #
  # ==== Format
  # * HTML
  def view
    @match = Match.find(params[:id])
    @attendance = MatchesHelper::preprocess_attendance(@match)
    @attendance_players = @match.get_players_attendance_str(current_user.player.team)
    
    @comment = Comment.new
    @comment.match = @match
    
    respond_to do |format|
      format.html {
        # just render
      }
    end
  end
end
