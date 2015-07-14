require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:user) { create(:user) }

  describe '#show' do
    let(:list) { create(:list, user: user) }
    before do
      get :show, { id: list.to_param }, user_id: user.id
    end
    it 'renders show' do
      expect(response).to render_template('lists/show')
    end
  end

  describe '#create' do
    context 'with valid params' do
      before do
        post :create, { list: { title: 'title' } }, user_id: user.id
      end
      it 'creates list' do
        expect(List.last.title).to eq('title')
      end
      it 'has no error' do
        expect(assigns(:new_list).errors).to be_empty
      end
      it 'redirects to list' do
        expect(response).to redirect_to(list_path(List.last))
      end
    end
    context 'with invalid params' do
      before do
        post :create, { list: { title: '' } }, user_id: user.id
      end
      it 'does not create list' do
        expect(List.last).to eq(nil)
      end
      it 'has errors' do
        expect(assigns(:new_list).errors).to_not be_empty
      end
      it 'sets errors to alert' do
        expect(flash[:alert]).to eq(assigns(:new_list).errors.full_messages)
      end
      it 'renders dashboard' do
        expect(response).to render_template('welcome/dashboard')
      end
    end
  end

  describe '#update' do
    let(:list) { create(:list, user: user) }
    context 'with valid params' do
      context 'format is json' do
        before do
          patch :update, { id: list.to_param, list: { title: 'title' }, format: :json }, user_id: user.id
        end
        it 'updates list' do
          expect(list.reload.title).to eq('title')
        end
        it 'has no error' do
          expect(assigns(:list).errors).to be_empty
        end
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end
      context 'format is html' do
        before do
          patch :update, { id: list.to_param, list: { title: 'title' } }, user_id: user.id
        end
        it 'updates list' do
          expect(list.reload.title).to eq('title')
        end
        it 'has no error' do
          expect(assigns(:list).errors).to be_empty
        end
        it 'redirects to list' do
          expect(response).to redirect_to(list_path(list.to_param))
        end
      end
    end
    context 'with invalid params' do
      before do
        patch :update, { id: list.to_param, list: { title: '' } }, user_id: user.id
      end
      it 'does not update list' do
        expect(list.title).to_not eq('title')
      end
      it 'has errors' do
        expect(assigns(:list).errors).to_not be_empty
      end
      it 'renders errors' do
        expect(response.body).to eq(assigns(:list).errors.full_messages.to_json)
      end
    end
  end

  describe '#destroy' do
    let(:list) { create(:list, user: user) }
    before do
      delete :destroy, { id: list.to_param }, user_id: user.id
    end
    it 'destroys list' do
      expect(List.find_by(id: list.id)).to eq(nil)
    end
    it 'redirects to dashboard' do
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
