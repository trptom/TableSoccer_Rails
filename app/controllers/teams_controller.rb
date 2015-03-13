# coding:utf-8

include TeamsHelper

class TeamsController < ApplicationController
  before_filter :require_admin, :except => [ :matches, :squad ]
  before_filter :require_login, :only => [ :matches, :squad ]
  
  # GET /teams
  def index
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /teams/new
  def new
    @team = Team.new

    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.teams.form.back_to_list"), :url => teams_path, :html_options => {} }
        ]
      }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.teams.edit.back_to_detail"), :url => @team , :html_options => {} },
          { :body => I18n.t("messages.teams.form.back_to_list"), :url => teams_path, :html_options => {} }
        ]
      }
    end
  end

  # POST /teams
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html {
          redirect_to @team, notice: I18n.t("messages.teams.create.success")
        }
      else
        format.html {
          @errors = @team.errors
          render action: "new"
        }
      end
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html {
          redirect_to @team, notice: I18n.t("messages.teams.update.success")
        }
      else
        format.html {
          @errors = @team.errors
          render action: "edit"
        }
      end
    end
  end

  # DELETE /teams/1
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html {
        redirect_to teams_url
      }
    end
  end
  
  def matches
    @matches = Match.by_team_id(params[:id]).order(:start_date)
    
    respond_to do |format|
      format.html # just render
    end
  end
  
  def squad
    @team = Team.find(params[:id])
    @players = @team.players.all.sort{ |a,b| a.nick_or_name <=> b.nick_or_name }
    @bounding_matches = get_bounding_matches_of_last_season
    
    respond_to do |format|
      format.html # just render
    end
  end
  
  # Counts partitial payments for each player in some time range. Amount is
  # splitted dependently on how many games has player played within that
  # range.
  #
  # ==== Required params
  # _id_:: id of _Team_ for which money stats should be counted.
  # _amount_:: amount to be counted between all players, based on their
  # attendance to matches and games played.
  # _fromDate_:: start date for recounting (matches before this date will not be
  # used).
  # _toDate_:: end date for recounting (matches after this date will not be
  # used).
  #
  # ==== Format
  # * JSON
  def recount_money
    @team = Team.find(params[:id])
    @money = get_money_array(@team, params[:amount].to_f, params[:fromDate], params[:toDate])
    
    respond_to do |format|
      format.json {
        render json: @money
      }
    end
  end
end
