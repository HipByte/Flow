# Net

HTTP networking / host reachability library.

## Usage

### Simple usage

#### GET json

```ruby
Net.get("https://httpbin.org/get?user_id=1") do |response|
  if response.status == 200
    response.body['args']['user_id'] # 1
  end
end
```

#### POST json

```ruby
options = {
  headers: {
    content_type: :json # 'Content-Type' => 'application/json' would also be valid
  },
  body: {user_id: 1}
}
Net.post("https://httpbin.org/post", options) do |response|
  if response.status == 200
    response.body['json']['user_id'] # 1
  end
end
```

### Advanced usage

#### Share a session with common configuration

```ruby
session = Net.build('https://httpbin.org') do
  header(:content_type, :json)
end

session.get("/users") do |response|
end

session.get("/posts") do |response|
end
```

#### Basic HTTP auth

```ruby
session = Net.build('https://httpbin.org') do
  authorize(username: 'rubymotion', password: 'flow')
end

session.get("/basic-auth/rubymotion/flow") do |response|
  if response.status == 200
    response.body['authenticated'] # true
  end
end
```

#### Reachability

You can track the reachability of a hostname using Net

```ruby
# this block will be called each time network status is updated
reachability = Net.reachable?("www.google.fr") do |reachable|
  if reachable
    ###
  end
end

# stop network reachability tracking
reachability.stop
```

#### Stubbing

Flow::Net has stubbing out of the box. Testing network calls without hitting
is very easy.

```ruby
Net.stub('www.example.com').and_return(Response.new(body:"example"))
Net.get("www.example.com") do |response|
  response.body # example
end
```

## TODO

* [x] Support for Json
* [x] Support for http verbs
* [x] Support for auth
* [ ] Support for upload
* [ ] Support for streaming
* [ ] Support for simple image fetching
