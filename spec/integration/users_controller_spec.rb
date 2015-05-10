require 'rails_helper'

# standard, non-nested resource
describe UsersController, type: :controller do

    describe '#index' do
      it 'sets the collection' do
        create(:user)
        get :index

        expect(assigns(:users)).to be_present
      end
    end

    describe '#show' do

      it 'gets the resource' do
        user = create(:user)
        get :show, id: user.id

        expect(assigns(:user)).to eq user
      end
    end

    describe '#new' do
      it 'creates an instance of the object' do
        get :new
        expect(assigns(:user)).to be_new_record
      end
    end

    describe '#edit' do


      it 'sets the instance of the object' do
        user = create(:user)
        get :edit, id: user.id
        expect(assigns(:user)).to eq user
      end
    end

    describe '#create' do
      it 'creates and persists a new object' do
        expect{
          post :create, user: build(:user).attributes
        }.to change(User, :count).by 1

        expect(assigns(:user)).to be_present
      end

      it 'does not create' do
        expect{
          post :create
        }.to change(User, :count).by 0
      end
    end

    describe '#update' do
      it 'updates and persists changes' do
        user = create(:user)
        put :update, id: user.id,
          user: { name: "updated" }

        updated_user = assigns(:user)
        expect(updated_user.name).to eq "updated"
      end

      it 'does not update' do
        user = create(:user)
        put :update, id: user.id, user: { name: "" }

        updated_user = assigns(:user)
        expect(updated_user.errors.full_messages.count).to eq 1
      end
    end


    describe '#destroy' do
      it 'destroys the object' do
        user = create(:user)

        expect{
          delete :destroy, id: user.id
        }.to change(User.all, :count).by -1
      end
    end


end
