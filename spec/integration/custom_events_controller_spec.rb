require 'rails_helper'

describe CustomEventsController, type: :controller do

  describe 'serializer is set' do
    it 'uses the serializer' do
      create(:event)
      get :index, format: :json
      body = response.body
      ap body
    end
  end


end
