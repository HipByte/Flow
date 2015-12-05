# Flow

Flow is a set of cross-platform libraries for RubyMotion. It can be seen as RubyMotion's missing standard library.

Each library implements the following requirements:

* Simple Ruby API
* 100% cross-platform (iOS and Android)
* No external dependencies
* Covered by tests
* Documented

## Libraries

Flow is currently composed of the following libraries:

* [**Net**](https://github.com/jjaffeux/Flow/tree/master/flow/net) - HTTP networking
* [**JSON**](https://github.com/jjaffeux/Flow/tree/master/flow/json) - JSON serialization
* [**Digest**](https://github.com/jjaffeux/Flow/tree/master/flow/digest) - Digest cryptography
* [**Store**](https://github.com/jjaffeux/Flow/tree/master/flow/digest) - Key-value store

## Usage

### Installing

Flow comes as a gem. 

```
$ sudo gem install motion-flow
```

### Projects

#### Flow projects

Flow comes with its own RubyMotion template, which creates a hybrid (iOS + Android) project.

```
$ motion create --template=flow Hello
$ cd Hello
$ rake -T
```

#### RubyMotion projects

Flow can be added as a dependency of an existing iOS or Android RubyMotion project, by adding the `motion-flow` gem in the project's `Gemfile`.
