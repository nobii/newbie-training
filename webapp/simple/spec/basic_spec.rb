require 'spec_helper'

describe 'Simple Hello World App' do

  let(:app) { Rack::Builder.parse_file('config.ru').first }

  it 'says hello' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.header['Content-Type']).to eq('text/html; charset=UTF-8')
    expect(last_response.body).to eq('Hello World')
  end

end
