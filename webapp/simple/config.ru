app = Proc.new do |env|
  [
    200,
    { 'Content-Type' => 'text/html/; charset=utf-8' },
    ['Hello World']
  ]
end

run app
