# Flow::Store

Key/value storage.

This library was inspired by https://github.com/GantMan/PackingPeanut.

## Documentation

### Public API

#### Set a value for a key

```ruby
Store['key'] = value
```

#### Get the value of a key

```ruby
Store['key']
```

#### Delete a key

```ruby
Store.delete('key')
```

#### Get all keys

```ruby
Store.all
```
