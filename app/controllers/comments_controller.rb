# coding:utf-8

class CommentsController < ApplicationController
  before_filter :require_login, :only => [:create]
  before_filter :require_admin, :only => [:hide]
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html {
          redirect_back_or_to "/", notice: I18n.t("messages.comments.create.success")
        }
      else
        format.html {
          @errors = @comment.errors
          redirect_back_or_to "/"
        }
      end
    end
  end

  def hide
    @comment = Comment.find(params[:id])
    @comment.visible = false;
    @res = @comment.save
    
    respond_to do |format|
      format.html {
        redirect_back_or_to "/", notice: I18n.t("messages.comments.create.#{@res ? 'success' : 'error'}")
      }
    end
  end
end
