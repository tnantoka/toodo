class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i(show update destroy)

  def show
  end

  def create
    @new_list = List.new(list_params)
    @new_list.user = current_user

    if @new_list.save
      redirect_to @new_list, notice: t('flash.application.created', resource_name: List.model_name.human)
    else
      flash[:alert] = @new_list.errors.full_messages
      render template: 'welcome/dashboard'
    end
  end

  def update
    if @list.update(list_params)
      respond_to do |format|
        format.html {
          redirect_to @list, notice: t('flash.application.updated', resource_name: List.model_name.human)
        }
        format.json { head :no_content }
      end
    else
      render json: @list.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to :dashboard, notice: t('flash.application.destroyed', resource_name: List.model_name.human)
  end

  private
    def list_params
      params.require(:list).permit(:title, :content, :gist)
    end

    def set_list
      @list = current_user.lists.find_by!(slug: params[:id])
    end
end
