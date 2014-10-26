# coding:utf-8

class LeagueTeamsController < ApplicationController
  before_filter :require_admin
  
  # Creates new connection between _League_ and _Team_.
  #
  # ==== Required params
  # _league_team_:: contains all attributes of _LeagueTeam_ which should be
  # created.
  #
  # ==== Format
  # * HTML
  def create
    @league_team = LeagueTeam.new(params[:league_team])

    respond_to do |format|
      if @league_team.save
        format.html { redirect_to :back, notice: 'Propojení týmu s ligou úspěšně vytvořeno.' } # TODO jsem kokot a tohle jsme asi jeste neprakopal - DODELAT!!!
      else
        format.html { redirect_to :back }
      end
    end
  end

  def update
    @league_team = LeagueTeam.find(params[:id])

    respond_to do |format|
      if @league_team.update_attributes(params[:league_team])
        format.html { redirect_to :back, notice: 'Propojení týmu s ligou úspěšně aktualizováno.' } # TODO jsem kokot a tohle jsme asi jeste neprakopal - DODELAT!!!
      else
        format.html { redirect_to :back }
      end
    end
  end

  # Deletes connection between _League_ and _Team_.
  #
  # ==== Required params
  # _id_:: id of connection that should be deleted.
  #
  # ==== Format
  # * HTML
  def destroy
    @league_team = LeagueTeam.find(params[:id])
    @league_team.destroy

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
end
