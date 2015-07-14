class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
    @rate_limit = @user.rate_limit if @user.gist?
  end

  def update
    if @user.update(user_params)
      redirect_to :edit_user, notice: t('flash.application.updated', resource_name: User.model_name.human)
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:nickname, :email)
    end

    def set_user
      @user = User.find(current_user.id)
    end
end
