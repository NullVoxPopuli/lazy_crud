require 'spec_helper'

describe LazyCrud do

  class Example < ActionController::Base
    include LazyCrud

    before_create -> (resource){ 2+2 }
    before_update -> (resource){ 2+2 }
    before_destroy -> (resource){ 2+2 }

  end


  describe '#build_method' do

    it 'uses build when the resource_proxy is a class' do
      example = Example.new
      allow(example).to receive(:resource_proxy){ Example }

      expect(example.send(:build_method)).to eq :new
    end

  end


  context 'calling a hook adds it to the hook list' do

    it 'before_create appends to the hook list' do
      hooks = Example.before_create_hooks
      expect(hooks.count).to eq 1
    end

    it 'before_update appends to the hook list' do
      hooks = Example.before_update_hooks
      expect(hooks.count).to eq 1
    end

    it 'before_destroy appends to the hook list' do
      hooks = Example.before_destroy_hooks
      expect(hooks.count).to eq 1
    end

  end


end
