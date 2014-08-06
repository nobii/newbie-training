require 'spec_helper'

describe 'top' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  it 'response collectly' do
  end
end

describe 'signup' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  context 'success' do
    it 'returns html' do
    end

    it 'success to signup' do
    end
  end

  context 'csrf error' do
  end

  context 'validation error' do
  end
end

describe 'signout' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }
end

describe 'signin' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  context 'success' do
  end

  context 'failed' do
  end
end

describe 'top' do
end
