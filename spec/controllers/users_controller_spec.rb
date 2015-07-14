require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe '#edit' do
    before do
      get :edit, nil, user_id: user.id
    end
    it 'renders edit' do
      expect(response).to render_template('users/edit')
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        patch :update, { user: { nickname: 'nickname' } }, user_id: user.id
      end
      it 'updates user' do
        expect(user.reload.nickname).to eq('nickname')
      end
      it 'has no error' do
        expect(assigns(:user).errors).to be_empty
      end
      it 'redirects to edit_user' do
        expect(response).to redirect_to(edit_user_path)
      end
    end
    context 'with invalid params' do
      before do
        patch :update, { user: { nickname: '' } }, user_id: user.id
      end
      it 'does not update user' do
        expect(user.reload.nickname).to_not eq('')
      end
      it 'has errors' do
        expect(assigns(:user).errors).to_not be_empty
      end
      it 'renders edit' do
        expect(response).to render_template('users/edit')
      end
    end
  end
end
