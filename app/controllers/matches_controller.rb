class MatchesController < ApplicationController
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
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
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
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
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
    if (@game.game_number == 3)||(@game.game_number == 4)||(@game.game_number == 10)
      @game.game_type = GAME_TYPE_SINGLE
    end
    if (@game.game_number == 1)||(@game.game_number == 2)||((@game.game_number >= 6)&&(@game.game_number <= 9))
      @game.game_type = GAME_TYPE_DOUBLE
    end
    if (@game.game_number == 5)
      @game.game_type = GAME_TYPE_FOURS
    end
    @game.save

    redirect_to @match
  end
end
