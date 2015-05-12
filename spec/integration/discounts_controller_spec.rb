require 'rails_helper'

# this is a nested resource
describe DiscountsController, type: :controller do

  before(:each) do
    @user = create(:user)
    @event = create(:event, user: @user)
  end

  describe '#index' do
    before(:each) do
      create(:discount, event: @event)
    end

    it 'sets the collection' do
      get :index, event_id: @event.id

      expect(assigns(:discounts)).to be_present
    end

    it 'returns json' do
      get :index, event_id: @event.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

  describe '#show' do

    it 'gets the resource' do
      discount = create(:discount, event: @event)
      get :show, event_id: @event.id, id: discount.id

      expect(assigns(:discount)).to eq discount
    end

    it 'returns json' do
      discount = create(:discount, event: @event)
      get :show, event_id: @event.id, id: discount.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

  describe '#new' do
    it 'creates an instance of the object' do
      get :new, event_id: @event.id

      expect(assigns(:discount)).to be_new_record
    end

    it 'returns json' do
      get :new, event_id: @event.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

  describe '#edit' do

    it 'sets the instance of the object' do
      discount = create(:discount, event: @event)
      get :edit, event_id: @event.id, id: discount.id
      expect(assigns(:discount)).to eq discount
    end
  end

  describe '#create' do
    it 'creates and persists a new object' do
      expect{
        post :create, event_id: @event.id, discount: build(:discount).attributes
      }.to change(Discount, :count).by 1

      expect(assigns(:discount)).to be_present
    end

    it 'returns json' do
      post :create, event_id: @event.id, discount: build(:discount).attributes, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

  describe '#update' do
    it 'updates and persists changes' do
      discount = create(:discount, event: @event)
      put :update, event_id: @event.id, id: discount.id,
        discount: { name: "updated" }

      field = assigns(:discount)
      expect(field.name).to eq "updated"
    end

    it 'returns json' do
      discount = create(:discount, event: @event)
      put :update, event_id: @event.id, id: discount.id,
        discount: { name: "updated" }, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end


  describe '#destroy' do
    it 'destroys the object' do
      discount = create(:discount, event: @event)

      expect{
        delete :destroy, event_id: @event.id, id: discount.id
      }.to change(@event.discounts, :count).by -1

      expect(assigns(:discount).deleted_at).to be_present
    end

    it 'returns json' do
      discount = create(:discount, event: @event)
      delete :destroy, event_id: @event.id, id: discount.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end


  describe '#undestroy' do
    it 'un destroys the object' do
      discount = create(:discount, event: @event, deleted_at: Time.now)

      expect{
        post :undestroy, event_id: @event.id, id: discount.id
      }.to change(@event.discounts, :count).by 1
      expect(assigns(:discount)).to be_present
    end

    it 'returns json' do
      discount = create(:discount, event: @event, deleted_at: Time.now)
      post :undestroy, event_id: @event.id, id: discount.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end


end
