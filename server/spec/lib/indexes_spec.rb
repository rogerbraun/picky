require 'spec_helper'

describe Picky::Indexes do

  let(:index) { stub :some_index, :name => :some_index }

  context 'with instance' do
    let(:indexes) { Picky::Indexes.new }

    describe 'indexes' do
      it 'exists' do
        lambda { indexes.indexes }.should_not raise_error
      end
      it 'is empty by default' do
        indexes.indexes.should be_empty
      end
    end
  end

  context 'with singleton' do
    let(:indexes) { Picky::Indexes.instance }

    describe 'indexes' do
      it 'exists' do
        lambda { indexes.indexes }.should_not raise_error
      end
    end

    describe 'clear_indexes' do
      it 'clears the indexes' do
        indexes.register index

        indexes.clear_indexes

        indexes.indexes.should == []
      end
    end

    describe 'register' do
      it 'adds the given index to the indexes' do
        indexes.clear_indexes

        indexes.register index

        indexes.indexes.should == [index]
      end
    end
  end

end