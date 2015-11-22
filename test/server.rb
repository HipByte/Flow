require 'sinatra'
require 'json'

get('/robots.txt') do
  [
    200,
    {"Content-Type" => "text/plain"},
    'User-agent: *'
  ]
end

get('/json') do
  [
    200,
    {"Content-Type" => "application/json"},
    {params: params, body: JSON.load(request.body)}.to_json
  ]
end

post('/') do
  [
    200,
    {"Content-Type" => "application/json"},
    {params: params, body: params}.to_json
  ]
end

post('/json') do
  [
    200,
    {"Content-Type" => "application/json"},
    {params: params, body: JSON.load(request.body)}.to_json
  ]
end
