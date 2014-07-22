class SimpleApp
  def call(env)
    # your webapp code here

    [
      200,
      { 'Content-Type' => 'text/html; charset=UTF-8' },
      ['Hello World']
    ]
  end
end
