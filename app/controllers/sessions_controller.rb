class SessionsController < ApplicationController
  before_action :authenticate_user!, except: %i(create failure setup)

  def create
    auth_hash = request.env['omniauth.auth']
    signed_in = signed_in?
    ActiveRecord::Base.transaction do
      identity = Identity.find_or_create_with_auth_hash!(auth_hash) 
      user = User.find_or_create_with_identity!(identity)

      if request.env['omniauth.params'].try(:[], 'scope') == 'gist'
        user.update!(gist: true)
      end

      self.current_user = user
        
      if signed_in
        redirect_to :edit_user, notice: t('flash.sessions.authenticated')
      else
        redirect_to :dashboard, notice: t('flash.sessions.signed_in')
      end
    end
  end

  def destroy
    self.current_user = nil
    redirect_to :root, notice: t('flash.sessions.signed_out')
  end

  def failure
    redirect_to :root, alert: t('flash.sessions.failed')
  end

  def setup
    if params[:scope] == 'gist'
      request.env['omniauth.strategy'].options[:scope] = 'gist'
    end
    render nothing: true, status: 404
  end
end
