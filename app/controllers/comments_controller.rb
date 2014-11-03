# coding:utf-8

# Controller containing actions for creating/hiding comments.
# 
# ==== See
# Comment
class CommentsController < ApplicationController
  
  before_filter :require_login, :only => [:create]
  before_filter :require_admin, :only => [:hide]

  # Creates new comment. Creating of comments should be allowed only for logged
  # users. When new comment created, _current_user_ is used as author.
  #
  # ==== Required params
  # _comment_:: contains all attributes of comment which should be created.
  #
  # ==== Format
  # * HTML
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

  # Hides comment. It is not possible to permanently delete comment, but when
  # you are an admin, you can hide (make invisible for all users) it by this
  # action.
  #
  # ==== Required params
  # _id_:: id of comment that should be hidden.
  #
  # ==== Format
  # * HTML
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
