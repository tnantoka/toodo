require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe '#create' do
    context 'when singed in' do
      before do
        request.env['omniauth.auth'] = auth_hash
        get :create, auth_hash
      end
      it 'sets current_user' do
        expect(session[:user_id]).to eq(User.last.id)
      end
      it 'sets signed_in to notice' do
        expect(flash[:notice]).to eq(I18n.t('flash.sessions.signed_in'))
      end
      it 'redirects to dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end
    context 'when singed in' do
      let(:identity) { Identity.find_or_create_with_auth_hash!(auth_hash) }
      let(:user) { User.find_or_create_with_identity!(identity) }
      before do
        request.env['omniauth.auth'] = auth_hash
        request.env['omniauth.params'] = { 'scope' => 'gist' }
        get :create, auth_hash, user_id: user.id
      end
      it 'sets true to gist' do
        expect(user.reload.gist?).to eq(true)
      end
      it 'sets signed_in to notice' do
        expect(flash[:notice]).to eq(I18n.t('flash.sessions.authenticated'))
      end
      it 'redirects to dashboard' do
        expect(response).to redirect_to(edit_user_path)
      end
    end
  end

  describe '#destory' do
    before do
      delete :destroy, nil, user_id: user.id
    end
    it 'sets nil to current_user' do
      expect(session[:user_id]).to eq(nil)
    end
    it 'sets signed_out to notice' do
      expect(flash[:notice]).to eq(I18n.t('flash.sessions.signed_out'))
    end
    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#failure' do
    before do
      get :failure
    end
    it 'sets failed to alert' do
      expect(flash[:alert]).to eq(I18n.t('flash.sessions.failed'))
    end
    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#setup' do
    let(:user) { create(:user) }
    before do
      request.env['omniauth.auth'] = auth_hash
      request.env['omniauth.strategy'] = OmniAuth::Strategies::GitHub.new({})
      get :setup, auth_hash.merge(scope: :gist), user_id: user.id
    end
    it 'returns http not_found' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
