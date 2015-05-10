require 'spec_helper'

describe LazyCrud do

  class Example < ActionController::Base
    include LazyCrud
  end


  describe '#build_method' do

    it 'uses build when the resource_proxy is a class' do
      example = Example.new
      allow(example).to receive(:resource_proxy){ Example }

      expect(example.send(:build_method)).to eq :new
    end

  end


end
