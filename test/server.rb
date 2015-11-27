require 'sinatra'
require 'json'
require 'thin'
Thin::Logging.debug = true
Thin::Logging.trace = true

helpers do
  def restricted_area
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def http_protect!
    return if http_authorized?
    restricted_area
  end

  def token_protect!
    return if token_authorized?
    restricted_area
  end

  def token_authorized?
    request.env.fetch('HTTP_AUTHORIZATION', nil) &&
    'rubymotion' == request.env['HTTP_AUTHORIZATION'].match(/Token token="(.*)"/).captures.first
  end

  def http_authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['username', 'admin']
  end

  def payload_request
    body = request.body.read
    [
      200,
      {
        "Content-Type" => "application/json",
        "X-Request-Method" => request.env['REQUEST_METHOD']
      },
      {
        "args" => params,
        "data" => body,
        "json" => JSON.load(body)
      }.to_json
    ]
  end
end

get('/token_auth_protected') do
  token_protect!
  "Welcome"
end

get('/basic_auth_protected') do
  http_protect!
  "Welcome"
end

get('/') do
  [
    200,
    {
      "Content-Type": "application/json",
      "X-Request-Method" => request.env['REQUEST_METHOD']
    },
    {
      "args" => params
    }.to_json
  ]
end

post('/') do
  payload_request
end

patch('/') do
  payload_request
end

delete('/') do
  payload_request
end

put('/') do
  payload_request
end

options('/') do
  [
    200,
    {
      "X-Request-Method" => request.env['REQUEST_METHOD']
    },
    nil
  ]
end

head('/') do
  [
    200,
    {
      "X-Request-Method" => request.env['REQUEST_METHOD']
    },
    nil
  ]
end

get('/txt') do
  [
    200,
    {"Content-Type" => "text/plain"},
    "User: #{params['user']}"
  ]
end

post('/form') do
  [
    200,
    {"Content-Type" => "application/json"},

    {
      "args" => params,
      "data" => request.body.read,
      "json" => params
    }.to_json
  ]
end
