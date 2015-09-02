require 'rails_helper'

# this is a nested resource
describe HostedEvents::DiscountsController, type: :controller do

  before(:each) do
    @user = create(:user)
    @event = create(:event, user: @user)
  end

  describe '#index' do
    before(:each) do
      @discount = create(:discount, event: @event)
      create(:discount)
    end

    it 'sets the collection' do
      get :index, hosted_event_id: @event.id

      discounts = assigns(:discounts)
      expect(discounts).to be_present
      expect(discounts).to include(@discount)
    end

    it 'returns json' do
      get :index, hosted_event_id: @event.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

end
