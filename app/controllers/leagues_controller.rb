include LeaguesHelper

class LeaguesController < ApplicationController
  before_filter :require_login, except: [:show]
  
  # GET /leagues
  def index
    @leagues = League.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /leagues/1
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

  # GET /leagues/new
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

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.leagues.edit.back_to_detail"), :url => @league , :html_options => {} },
          { :body => I18n.t("messages.leagues.form.back_to_list"), :url => leagues_path, :html_options => {} }
        ]
      }
    end
  end

  # POST /leagues
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

  # PUT /leagues/1
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

  # DELETE /leagues/1
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html {
        redirect_to leagues_url
      }
    end
  end
  
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
