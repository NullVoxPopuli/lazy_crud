require 'rails_helper'

# this is a nested resource
describe HostedEvents::DiscountsController, type: :controller do

  before(:each) do
    @user = create(:user)
    @event = create(:event, user: @user)
  end

  describe '#index' do
    before(:each) do
      create(:discount, event: @event)
    end

    it 'sets the collection' do
      get :index, hosted_event_id: @event.id

      expect(assigns(:discounts)).to be_present
    end

    it 'returns json' do
      get :index, hosted_event_id: @event.id, format: :json

      expect{
        JSON.parse(response.body)
      }.to_not raise_error
    end
  end

end
