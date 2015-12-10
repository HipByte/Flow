# Flow::Digest*

Cryprographic digest functions.

## Documentation

### Public API

Each digest algorithm is wrapped into a separate class, and implements the same set of methods:

- `Digest::MD5`
- `Digest::SHA1`
- `Digest::SHA224`
- `Digest::SHA256`
- `Digest::SHA385`
- `Digest::SHA512`

#### Quick digest

```ruby
Digest::MD5.digest('hello') #=> '5d41402abc4b2a76b9719d911017c592'
```

#### Create digest instance

```ruby
digest = Digest::MD5.new
```

#### Update digest instance with string

```ruby
digest.update('hello')
```

#### Clear digest instance

```ruby
digest.reset
```

#### Generate hash from digest instance

```ruby
digest.digest #=> '5d41402abc4b2a76b9719d911017c592'
```
