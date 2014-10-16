class TeamsController < ApplicationController
  before_filter :require_admin, :except => [ :matches ]
  before_filter :require_login, :only => [ :matches ]
  
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
  end
end
