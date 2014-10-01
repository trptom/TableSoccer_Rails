class PlayersController < ApplicationController
  before_filter :require_login, except: [:show]
  
  # GET /players
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /players/1
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /players/new
  def new
    @player = Player.new

    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.players.form.back_to_list"), :url => players_path, :html_options => {} }
        ]
      }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
    
    respond_to do |format|
      format.html {
        @buttons = [
          { :body => I18n.t("messages.players.form.back_to_detail"), :url => @player , :html_options => {} },
          { :body => I18n.t("messages.players.form.back_to_list"), :url => players_path, :html_options => {} }
        ]
      }
    end
  end

  # POST /players
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html {
          redirect_to @player, notice: I18n.t("messages.players.create.success")
        }
      else
        format.html {
          @errors = @league.errors
          render action: "new"
        }
      end
    end
  end

  # PUT /players/1
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html {
          redirect_to @player, notice: I18n.t("messages.players.update.success")
        }
      else
        format.html {
          @errors = @league.errors
          render action: "edit"
        }
      end
    end
  end

  # DELETE /players/1
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html {
        redirect_to players_url
      }
    end
  end
end
