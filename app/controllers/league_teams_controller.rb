class LeagueTeamsController < ApplicationController
  # GET /league_teams
  # GET /league_teams.json
  def index
    @league_teams = LeagueTeam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @league_teams }
    end
  end

  # GET /league_teams/1
  # GET /league_teams/1.json
  def show
    @league_team = LeagueTeam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @league_team }
    end
  end

  # GET /league_teams/new
  # GET /league_teams/new.json
  def new
    @league_team = LeagueTeam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @league_team }
    end
  end

  # GET /league_teams/1/edit
  def edit
    @league_team = LeagueTeam.find(params[:id])
  end

  # POST /league_teams
  # POST /league_teams.json
  def create
    @league_team = LeagueTeam.new(params[:league_team])

    respond_to do |format|
      if @league_team.save
        format.html { redirect_to @league_team, notice: 'League team was successfully created.' }
        format.json { render json: @league_team, status: :created, location: @league_team }
      else
        format.html { render action: "new" }
        format.json { render json: @league_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /league_teams/1
  # PUT /league_teams/1.json
  def update
    @league_team = LeagueTeam.find(params[:id])

    respond_to do |format|
      if @league_team.update_attributes(params[:league_team])
        format.html { redirect_to @league_team, notice: 'League team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @league_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /league_teams/1
  # DELETE /league_teams/1.json
  def destroy
    @league_team = LeagueTeam.find(params[:id])
    @league_team.destroy

    respond_to do |format|
      format.html { redirect_to league_teams_url }
      format.json { head :no_content }
    end
  end
end
