# Store

Simple key/value storage library.

This library was inspired by https://github.com/GantMan/PackingPeanut.

## Documentation

### Public API

#### Set a value for a key

```ruby
Store['key'] = 42
```

#### Get the value of a key

```ruby
Store['key']
```

#### Delete a key

```ruby
Store.delete('key')
```

#### Get all keys/values

```ruby
Store.all #=> { 'hey' => 42 }
```
