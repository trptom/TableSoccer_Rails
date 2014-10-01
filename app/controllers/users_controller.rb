class UsersController < ApplicationController
  before_filter :require_login, except: [:new, :create, :show, :activate]
  
  def index
    @users = User.all
  end

  def show
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
      # presmeruju na seznam uzivatelu, pokud neni zdrojem aktivace email
      redirect_to "/home", notice: I18n.t("messages.base.user_activated")
    else
      not_authenticated
    end
  end
  
  def reset_password
    # just render form
  end
end
