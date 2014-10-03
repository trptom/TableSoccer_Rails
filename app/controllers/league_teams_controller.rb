# coding:utf-8

class LeagueTeamsController < ApplicationController
  before_filter :require_admin
  
  def create
    @league_team = LeagueTeam.new(params[:league_team])

    respond_to do |format|
      if @league_team.save
        format.html { redirect_to :back, notice: 'Propojení týmu s ligou úspěšně vytvořeno.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def update
    @league_team = LeagueTeam.find(params[:id])

    respond_to do |format|
      if @league_team.update_attributes(params[:league_team])
        format.html { redirect_to :back, notice: 'Propojení týmu s ligou úspěšně aktualizováno.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    @league_team = LeagueTeam.find(params[:id])
    @league_team.destroy

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
end
