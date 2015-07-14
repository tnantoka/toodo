require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  render_views
  let(:user) { create(:user) }

  describe '#index' do
    context 'when signed in' do
      before do
        get :index, nil, user_id: user.id
      end
      it 'redirects to dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end
    context 'when signed out' do
      before do
        get :index
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
    context 'with params[:locale]' do
      before do
        get :index, { locale: :ja }
      end
      it 'sets ja to locale' do
        expect(I18n.locale).to eq(:ja)
      end
    end
  end

  describe '#dashboard' do
    context 'when signed in' do
      before do
        get :dashboard, nil, user_id: user.id
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
    context 'when signed out' do
      before do
        get :dashboard
      end
      it 'returns to root' do
        expect(response).to redirect_to(root_path)
      end
      it 'set unauthenticated to alert' do
        expect(flash[:alert]).to eq(I18n.t('flash.application.unauthenticated'))
      end
    end
  end
end
