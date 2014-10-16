class UsersController < ApplicationController
  before_filter :require_admin, :only => [ :index, :destroy, :activate_manually ]
  before_filter :require_login, :only => [ :fill_attendance, :add_attendance, :remove_attendance, :edit, :update , :show ]
  before_filter :require_not_logged, :only => [ :new, :create, :activate, :reset_password, :login ]
  
  def index
    @users = User.all
  end

  def show
    filter(current_user.id == params[:id].to_i || current_user.is_admin)
    
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    filter(current_user.id == params[:id].to_i || current_user.is_admin)
    
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html {
        if current_user && current_user.is_admin
          @buttons = [
            { :body => I18n.t("messages.users.form.back_to_detail"), :url => @user , :html_options => {} },
            { :body => I18n.t("messages.users.form.back_to_list"), :url => users_path, :html_options => {} }
          ]
        end
      }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html {
          if (current_user)
            redirect_to @user, notice: I18n.t("messages.users.create.success")
          else
            redirect_to "/", notice: I18n.t("messages.users.create.success")
          end
        }
      else
        format.html {
          @errors = @user.errors
          render action: "new"
        }
      end
    end
  end

  def update
    filter(current_user.id == params[:id].to_i || current_user.is_admin)
    
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {
          redirect_to @user, notice: I18n.t("messages.users.update.success")
        }
      else
        format.html {
          @errors = @user.errors
          render action: "edit"
        }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html {
        redirect_to "/"
      }
    end
  end
  
  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      UserMailer.activation_success_email(@user).deliver
      redirect_to "/", notice: I18n.t("messages.base.user_activated")
    else
      not_authenticated
    end
  end
  
  def reset_password
    # just render form
  end
  
  def login
    # just render form
  end
  
  def activate_manually
    @user = User.find(params[:id])
    @user.activate!

    redirect_to @user
  end
  
  def fill_attendance
    filter(current_user.player != nil)
    
    @matches = Match.by_player(current_user.player)
    if (params[:selected])
      @selected = Match.find(params[:selected])
    else
      @selected = @matches.first
    end
  end
  
  def add_attendance
    filter(current_user.player != nil)
    
    @date = PossibleDateSelection.new(
      :possible_date_id => params[:dateId],
      :player_id => current_user.player.id,
      :start_time => params[:from],
      :end_time => params[:to],
      :priority => params[:priority]
    )
    @status = @date.save
    
    respond_to do |format|
      format.json {
        render json: {
          :date => @date,
          :status => @status,
          :formatted_start => I18n.l(@date.start_time, :format => :short),
          :formatted_end => I18n.l(@date.end_time, :format => :short),
          :priority => "(#{I18n.t('messages.priority.short.p' + @date.priority.to_s)})"
        }
      }
    end
  end
  
  def remove_attendance
    filter(current_user.player != nil)
    
    @date = PossibleDateSelection.find(params[:id])
    @date.destroy

    respond_to do |format|
      format.json {
        render json: {}
      }
    end
  end
end
