# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/url_for'
require 'erubis'
require 'mysql2-cs-bind'
require 'bcrypt'
require 'json'

require 'ext/object/blank'
require 'formvalidator/lite'
require 'html/fillinform/lite'

set :erb, :escape_html => true

helpers do
  def load_config
    {
      :database => {
        :host     => '127.0.0.1',
        :port     => '3306',
        :username => 'root',
        :password => '',
        :dbname   => 'test',
      },
      :recent_posts_limit => 100,
      :recent_posts_cache_file => 'public/cache.json'
    }
  end

  def connection
    config = load_config[:database]
    return $mysql if $mysql

    $mysql = Mysql2::Client.new(
      :host      => config[:host],
      :port      => config[:port],
      :username  => config[:username],
      :password  => config[:password],
      :database  => config[:dbname],
      :reconnect => true,
    )
  end

  def recent_posts
    cache_file_name = load_config[:recent_posts_cache_file]

    if File.exists?(cache_file_name) then
      cache_file = File.open(cache_file_name, 'r')
      recent_posts = JSON.parse(cache_file.read)
      return recent_posts
    end

    recent_posts_limit = load_config[:recent_posts_limit]

    mysql = connection
    posts = mysql.xquery(
      "SELECT posts.id AS id, users.username AS user_username, content, stars_count FROM posts JOIN users ON users.id = posts.user_id ORDER BY created_at DESC LIMIT #{recent_posts_limit}"
    )

    recent_posts = []
    posts.each do |post|
      recent_posts.push({
        'id'       => post['id'],
        'username' => post['user_username'],
        'stars'    => post['stars_count'],
        'headline' => post['content'].slice(0, 30)
      })
    end

    cache_file = File.open(cache_file_name, 'w')
    cache_file.write(recent_posts.to_json)
    cache_file.close

    recent_posts
  end

  def u(str)
    URI.escape(str.to_s)
  end

end

before do
  @session = session
end

get '/' do
  @recent_posts = recent_posts
  @errors       = Hash.new {|h,k| h[k] = {}}

  erb :index
end

post '/post' do
  username = session[:username]
  if username.nil?
    halt 400, 'invalid request'
  end

  validator = FormValidator::Lite.new(request)
  result = validator.check(
    'content', %w( NOT_NULL )
  )

  if result.has_error?
    @recent_posts = recent_posts
    @errors = result.errors
    body = erb :index
    return HTML::FillinForm::Lite.new.fill(body, request)
  end

  mysql = connection
  user = mysql.xquery(
    'SELECT id FROM users WHERE username=?',
    username
  ).first
  user_id = user['id']
  content = params['content']

  mysql.xquery(
    'INSERT INTO posts (user_id, content) VALUES (?, ?)',
    user_id, content
  )
  post_id = mysql.last_id

  cache_file_name = load_config[:recent_posts_cache_file]
  if File.exists?(cache_file_name) then
    File.unlink cache_file_name
  end

  redirect to("/post/#{post_id}")
end

get '/post/:id' do
  post_id = params[:id]

  mysql = connection
  post = mysql.xquery(
    'SELECT posts.id, users.username AS user_username, content, created_at, stars_count FROM posts JOIN users ON posts.user_id = users.id WHERE posts.id=?',
    post_id
  ).first
  if post.blank?
    halt 404, 'Not Found'
  end

  @post = {
    'id'         => post['id'],
    'content'    => post['content'],
    'username'   => post['user_username'],
    'stars'      => post['stars_count'],
    'created_at' => post['created_at']
  }
  @recent_posts = recent_posts

  erb :post
end

post '/star/:id' do
  username = session[:username]
  if username.nil?
    halt 400, 'invalid request'
  end

  post_id = params[:id]
  mysql = connection

  mysql.xquery(
    'UPDATE posts SET stars_count = stars_count + 1 WHERE posts.id = ?',
    post_id
  )

  cache_file_name = load_config[:recent_posts_cache_file]
  if File.exists?(cache_file_name) then
    File.unlink cache_file_name
  end

  redirect to("/post/#{post_id}")
end

get '/signin' do
  @errors = Hash.new {|h,k| h[k] = {} }
  erb :signin
end

get '/signout' do
  session.destroy
  redirect to('/')
end

post '/signin' do
  username = params[:username]
  password = params[:password]

  mysql = connection
  user = mysql.xquery(
    'SELECT password FROM users WHERE username=?',
    username
  ).first

  success = user.present?
  if success
    crypt   = BCrypt::Password.new(user['password'])
    success = (crypt == password)
  end

  if success
    # ログインに成功した場合
    session.clear
    session[:username] = username
    return redirect to('/')
  end

  # ログイン失敗した場合
  validator = FormValidator::Lite.new(request)
  validator.set_error('login', 'FAILED')
  @errors = validator.errors

  erb :signin
end

get '/signup' do
  @errors = Hash.new {|h,k| h[k] = {}}
  erb :signup
end

post '/signup' do
  username = params[:username]
  password = params[:password]

  validator = FormValidator::Lite.new(request)
  result = validator.check(
    'username', [%w(NOT_NULL), ['REGEXP', /\A[a-zA-Z0-9]{2,20}\z/]],
    'password', [%w(NOT_NULL ASCII), %w(LENGTH 2 20)],
    { 'password' => %w(password password_confirm) }, ['DUPLICATION']
  )

  mysql = connection
  user_count = mysql.xquery(
    'SELECT count(*) AS c FROM users WHERE username=?',
    username
  ).first['c']
  if user_count > 0
    validator.set_error('username', 'EXISTS')
  end

  # validationでエラーが起きたらフォームを再表示
  if validator.has_error?
    @errors = validator.errors
    body = erb :signup
    return HTML::FillinForm::Lite.new.fill(body, request)
  end

  salted = BCrypt::Password.create(password).to_s

  # validationを通ったのでユーザを作成
  mysql.xquery(
    'INSERT INTO users (username, password) VALUES (?, ?)',
    username, salted
  )

  session[:username] = username

  redirect to('/')
end
