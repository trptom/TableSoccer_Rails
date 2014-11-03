include LeaguesHelper

# Controller containing actions for creating/editing/viewing leagues. You can
# also draw league (means create default matches) by them.
# 
# ==== See
# League
class LeaguesController < ApplicationController
  before_filter :require_admin
  
  # Shows list of Leagues (for adimn).
  # 
  # ==== Format
  # * HTML
  def index
    @leagues = League.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # Shows detail of _League_ (for adimn).
  #
  # ==== Required params
  # _id_:: id of _League_ that should be shown.
  #
  # ==== Format
  # * HTML
  def show
    @league = League.find(params[:id])
    @teams_list = @league.league_teams.order(:season).all
    @teams = Hash.new
    @new_team = LeagueTeam.new

    @new_team.league = @league
    @new_team.season = Time.now.month <= 6 ? Time.now.year-1 : Time.now.year;

    for lt in @teams_list
      if (!@teams || !@teams[lt.season])
        @teams[lt.season] = Hash.new
        @teams[lt.season][:season] = lt.season
        @teams[lt.season][:lt] = Array.new
      end
      @teams[lt.season][:lt] << lt;
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # Shows form that serves to create new _League_.
  #
  # ==== Format
  # * HTML
  def new
    @league = League.new

    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.leagues.form.back_to_list"), :url => matches_path, :html_options => {} }
        ]
      }
    end
  end

  # Shows form to edit the _League_.
  #
  # ==== Required params
  # _id_:: id of _League_ to be edited.
  #
  # ==== Format
  # * HTML
  def edit
    @league = League.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.leagues.form.back_to_detail"), :url => @league , :html_options => {} },
          { :body => I18n.t("messages.leagues.form.back_to_list"), :url => leagues_path, :html_options => {} }
        ]
      }
    end
  end

  # Creates new _League_ based of params, sent from "new form".
  #
  # ==== Required params
  # _league_:: contains all attributes of _League_ which should be created.
  #
  # ==== Format
  # * HTML
  def create
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        format.html {
          redirect_to @league, notice: I18n.t("messages.leagues.create.success")
        }
      else
        format.html {
          @errors = @league.errors
          render action: "new"
        }
      end
    end
  end

  # Updates _League_ based of params, sent from "edit form".
  #
  # ==== Required params
  # _id_:: id of _League_ to be updated.
  # _league_:: contains all attributes of _League_ which should be updated.
  #
  # ==== Format
  # * HTML
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html {
          redirect_to @league, notice: I18n.t("messages.leagues.update.success")
        }
      else
        format.html {
          @errors = @league.errors
          render action: "edit"
        }
      end
    end
  end

  # Deletes _League_.
  #
  # ==== Required params
  # _id_:: id of _League_ that should be deleted.
  #
  # ==== Format
  # * HTML
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html {
        redirect_to leagues_url
      }
    end
  end
  
  # Draws a league. This means, that games for selected teams (or all teams,
  # contained in _League_) will be created.
  # 
  # ==== Required params
  # _id_:: id of _League_ that should be drawn.
  # _type_:: when 0, all teams will be drawn, otherwise _team_ param
  # is required.
  # _team_:: team for which all games should be drawn. (not required when _type_
  # is != 0)
  # _season_:: all games should be assigned to some season. This parameter
  # specifies the season.
  #
  # ==== Format
  # * HTML
  def draw
    @league = League.find(params[:id])
    
    if (params[:type] == "0")
      @team = nil
    else
      @team = Team.find(params[:team])
    end
    
    if LeaguesHelper::draw(@league, params[:season].to_i, @team)
      redirect_to @league, notice: I18n.t("messages.leagues.draw.success")
    else
      redirect_to @league
    end
  end
end
