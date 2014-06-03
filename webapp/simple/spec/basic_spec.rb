require 'spec_helper'

APP = Rack::Builder.parse_file('config.ru').first

describe 'Simple Hello World App' do

  def app
    APP
  end

  it 'says hello' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.header['Content-Type']).to eq('text/html/; charset=utf-8')
    expect(last_response.body).to eq('Hello World')
  end

end
