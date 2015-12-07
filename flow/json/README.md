# Flow::JSON

JSON serialization

## Documentation

### Public API

#### Deserialize a JSON string to a ruby object

```ruby
JSON.load('{"foo":"bar"}')
```

#### Serialize an object to a JSON string

```ruby
{"foo" => "bar"}.to_json
```
