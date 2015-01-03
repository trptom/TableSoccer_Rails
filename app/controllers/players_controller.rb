# coding:utf-8

# Controller used to creating/modyfying Players.
class PlayersController < ApplicationController
  
  before_filter :require_admin
  
  # Shows list of Players (for admin).
  # 
  # ==== Format
  # * HTML
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # Shows detail of _Player_ (for admin).
  #
  # ==== Required params
  # _id_:: id of _Player_ that should be shown.
  #
  # ==== Format
  # * HTML
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # Shows form that serves to create new _Player_.
  #
  # ==== Format
  # * HTML
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

  # Shows form to edit the _Player_.
  #
  # ==== Required params
  # _id_:: id of _Player_ to be edited.
  #
  # ==== Format
  # * HTML
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

  # Creates new _Player_ based of params, sent from "new form".
  #
  # ==== Required params
  # _player_:: contains all attributes of _Player_ which should be created.
  #
  # ==== Format
  # * HTML
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html {
          redirect_to @player, notice: I18n.t("messages.players.create.success")
        }
      else
        format.html {
          @errors = @player.errors
          render action: "new"
        }
      end
    end
  end

  # Updates _Player_ based of params, sent from "edit form".
  #
  # ==== Required params
  # _id_:: id of _Player_ to be updated.
  # _player_:: contains all attributes of _Player_ which should be updated.
  #
  # ==== Format
  # * HTML
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

  # Deletes _Player_.
  #
  # ==== Required params
  # _id_:: id of _Player_ that should be deleted.
  #
  # ==== Format
  # * HTML
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html {
        redirect_to players_url
      }
    end
  end
  
  # Adds black mark to _Player_.
  #
  # ==== Required params
  # _count_:: number of added dots.
  # _id_:: id of _Player_ to which black mark should be added.
  # _reason_:: number of reason or undefined when reason id should be null.
  # _description_:: additional description of reason (text).
  #
  # ==== Format
  # * JSON
  def add_black_dot
    reason = params[:reason] != nil && params[:reason] != "" ? params[:reason].to_i : nil
    count = params[:count] != nil && params[:count] != "" ? params[:count].to_i : 1
    desc = params[:description] != nil && params[:description] != "" ? params[:description] : nil
    
    ActiveRecord::Base.transaction do
      @dot = BlackDot.new
      @dot.count = count
      @dot.player_id = params[:id]
      @dot.reason = reason
      @dot.description = desc

      @res1 = @dot.save

      @player = Player.find(params[:id])
      @player.dots_total = @player.dots_total + count

      @res2 = @player.save
    end
    
    respond_to do |format|
      format.json {
        render json: {
          :status => @res1 && @res2,
          :dot => @dot,
          :reason => @dot.reason == nil ? nil : I18n.t("messages.black_dot_reason.reason" + @dot.reason.to_s),
          :description => @dot.description
        }
      }
    end
  end
  
  # Increases _beer_paid_ attribute of _Player_.
  #
  # ==== Required params
  # _id_:: id of _Player_ which attribute _beer_paid_ should be increased.
  #
  # ==== Format
  # * JSON
  def pay_beer
    @player = Player.find(params[:id])
    @player.beer_paid = @player.beer_paid + 1
    @res = @player.save
    
    respond_to do |format|
      format.json {
        render json: {
          :status => @res,
          :player => @player
        }
      }
    end
  end
end
