require 'spec_helper'

describe 'sample app' do

  let(:app) { Rack::Builder.parse_file('config.ru').first }

  it 'returns form' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.header['Content-Type']).to eq('text/html;charset=utf-8')
    expect(last_response.body).to match %r{<title>form</title>}
    expect(last_response.body).to match /Hello World/
  end

  it 'says hello to requested name' do
    get '/result', {name: 'Mr. FooBar'}
    expect(last_response).to be_ok
    expect(last_response.header['Content-Type']).to eq('text/html;charset=utf-8')
    expect(last_response.body).to match %r{<title>result</title>}
    expect(last_response.body).to match /Hello Mr\. FooBar/
  end

  it 'returns 404 when not found' do
    get '/xxx'
    expect(last_response).not_to be_ok
    expect(last_response.status).to eq(404)
  end

end
