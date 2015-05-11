require 'rails_helper'

describe EventsController, type: :controller do

  describe 'before_create' do
    it 'has 2 hooks' do
      hooks = controller.class.before_create_hooks
      expect(hooks.count).to eq 2
    end

    it 'calls before_create hooks' do

      expect(controller).to receive(:before_create)
      post :create, event: build(:event).attributes
    end

    it 'evaluates the before_create hooks' do
      attributes = build(:event).attributes
      post :create, event: attributes

      name = attributes["name"].upcase
      expected = name + " " + name
      actual = assigns(:event).name
      expect(actual).to eq expected
    end
  end

  describe 'before_update' do

    it 'calls before_update hooks' do
      event = create(:event)
      put :update, id: event.id, event: {}
      actual = assigns(:event).user_id
      expect(actual).to eq -1
    end

  end

  describe 'before_destroy' do

    it 'calls before_destroy hooks' do
      event = create(:event)
      expect(event.created_at).to_not eq nil
      delete :destroy, id: event.id
      expect(assigns(:event).created_at).to eq nil

    end
  end


end
