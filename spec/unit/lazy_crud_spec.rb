require 'spec_helper'

describe LazyCrud do

  class Parent # < ActiveRecord::Base

  end


  class Example # < ActiveRecord::Base

  end

  # Controller with both parent and plural resource name
  # plural resource name is standard for CRUD operations
  class Parent::ExamplesController < ActionController::Base
    include LazyCrud
  end

  # Controller with singular resource name
  class ExampleController < ActionController::Base
    include LazyCrud

    before_create -> (resource){ 2+2 }
    before_update -> (resource){ 2+2 }
    before_destroy -> (resource){ 2+2 }

  end

  describe '#set_default_resources' do
    it 'sets the model based on the controller name' do
      example = ExampleController.new

      expect(example.send(:resource_proxy)).to eq Example
    end

    it 'sets the model and parent based on the controller name' do
      parent_example = Parent::ExamplesController.new

      expect(parent_example.class.send(:resource_class)).to eq Example
      expect(parent_example.class.send(:parent_class)).to eq Parent
    end
  end


  describe '#build_method' do

    it 'uses build when the resource_proxy is a class' do
      example = ExampleController.new
      allow(example).to receive(:resource_proxy){ Example }

      expect(example.send(:build_method)).to eq :new
    end

  end


  context 'calling a hook adds it to the hook list' do

    it 'before_create appends to the hook list' do
      hooks = ExampleController.before_create_hooks
      expect(hooks.count).to eq 1
    end

    it 'before_update appends to the hook list' do
      hooks = ExampleController.before_update_hooks
      expect(hooks.count).to eq 1
    end

    it 'before_destroy appends to the hook list' do
      hooks = ExampleController.before_destroy_hooks
      expect(hooks.count).to eq 1
    end

  end


end
