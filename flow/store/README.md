# Flow::Store

Simple cross platform Key/Value store.
* Simple API
* Uses NSUserDefaults on iOS and SharedPreferences on Android

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
