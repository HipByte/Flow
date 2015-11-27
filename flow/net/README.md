# Flow::Net

HTTP networking

## Usage

### Simple usage

#### GET json

```ruby
Net.get("https://httpbin.org/get?user_id=1") do |response|
  if response.status == 200
    p response.body['args']['user_id'] # 1
  end
end
```

#### POST json

```ruby
options = {
  headers: {
    content_type: :json, # 'Content-Type' => 'application/json' would also be valid
    body: {user_id: 1}
  }
}
Net.post("https://httpbin.org/post", options) do |response|
  if response.status == 200
    p response.body['json']['user_id'] # 1
  end
end
```

### Advanced usage

#### Basic HTTP auth

```ruby
session = Net.build('https://httpbin.org') do
  authorize(username: 'rubymotion', password: 'flow')
end

session.get("/basic-auth/rubymotion/flow", options) do |response|
  if response.status == 200
    p response.body['authenticated'] # true
  end
end
```
