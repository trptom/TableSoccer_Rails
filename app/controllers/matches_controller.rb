include GamesHelper

class MatchesController < ApplicationController
  before_filter :require_login, except: [:show]
  
  # GET /matches
  def index
    @matches = Match.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /matches/1
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /matches/new
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /matches
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: I18n.t('messages.matches.create.success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /matches/1
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: I18n.t('messages.matches.update.success') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /matches/1
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

  def add_game
    @match = Match.find(params[:id])
    @game = Game.new
    @game.match = @match
    @game.game_number = @match.games.last ? @match.games.last.game_number+1 : 1;

    @game.game_type = get_preferred_game_type({ :game => @game })
    if (@game.game_number == 3)||
        (@game.game_number == 4)||
        (@game.game_number == 10)
      @game.game_type = GAME_TYPE_SINGLE
    end
    if (@game.game_number == 1)||
        (@game.game_number == 2)||
        ((@game.game_number >= 6)&&(@game.game_number <= 9))||
        (@game.game_number >= 11)
      @game.game_type = GAME_TYPE_DOUBLE
    end
    if (@game.game_number == 5)
      @game.game_type = GAME_TYPE_FOURS
    end
    @game.save

    redirect_to @match
  end
  
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

      @res = @games[a].save && @res
    end
    
    if @res
      redirect_to @match, notice: "TODO"
    else
      redirect_to @match
    end
  end
end
