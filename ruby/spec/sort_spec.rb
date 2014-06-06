require 'rspec'
require_relative '../lib/sorter'

describe 'Sorter Class' do

  context 'initialize' do
    before do
      @sorter = Sorter.new
    end

    it 'can be instanciated' do
      expect(@sorter).to be_instance_of(Sorter)
    end
  end

  context 'values' do
    before(:each) do
      @sorter = Sorter.new
    end

    it 'is initialized by empty array' do
      expect(@sorter.get_values).to eq([])
    end

    it 'can be set empty value' do
      @sorter.set_values
      expect(@sorter.get_values).to eq([])
    end

    it 'can be set single value' do
      @sorter.set_values(1)
      expect(@sorter.get_values).to eq([1])
    end

    it 'can be set multiple values' do
      @sorter.set_values(1, 2, 3, 4, 5)
      expect(@sorter.get_values).to eq([1, 2, 3, 4, 5])
    end
  end

  context 'sort' do
    before(:each) do
      @sorter = Sorter.new
    end

    it 'can sort empty value' do
      @sorter.sort
      expect(@sorter.get_values).to eq([])
    end

    it 'can sort single value' do
      @sorter.set_values(1)
      @sorter.sort
      expect(@sorter.get_values).to eq([1])
    end

    it 'can sort multiple values' do
      patterns = [
        [5, 4, 3, 2, 1],
        [-1, -2, -3, -4, -5],
        [1, 2, 3, 4, 5],
        [5, 5, 4, 4, 4, 3, 2, 1]
      ]

      patterns.each do |pattern|
        @sorter.set_values(*pattern)
        @sorter.sort
        expect(@sorter.get_values).to eq(pattern.sort)
      end
    end

    it 'sort random values' do
      5.times do
        random_values = []
        100.times do
          random_values.push((rand * 100 - 50).to_i)
        end

        @sorter.set_values(*random_values)
        @sorter.sort
        expect(@sorter.get_values).to eq(random_values.sort)
      end
    end
  end

end
