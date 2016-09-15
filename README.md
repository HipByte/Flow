[![Build Status](https://travis-ci.org/HipByte/Flow.svg?branch=master)](https://travis-ci.org/HipByte/Flow)

# Flow

<img src="https://github.com/HipByte/Flow/blob/master/flow-logo.png" alt="flow logo" width="300">

Flow is a set of cross-platform libraries for RubyMotion. It can be seen as RubyMotion's missing standard library.

Each library implements the following requirements:

* Simple Ruby API
* 100% cross-platform (iOS, Android and OS X)
* No external dependencies
* Covered by tests
* [API Documentation](http://www.rubymotion.com/developers/motion-flow/)

**WARNING**: Flow is currently a work in progress. Some specs might be broken, APIs might change, and documentation might be missing. We are working toward a stable release. If you want to help please get in touch.

## Libraries

Flow is currently composed of the following libraries:

* [**UI**](https://github.com/Hipbyte/Flow/tree/master/flow/ui) - User interface framework
* [**Net**](https://github.com/Hipbyte/Flow/tree/master/flow/net) - HTTP networking and host reachability
* [**JSON**](https://github.com/Hipbyte/Flow/tree/master/flow/json) - JSON serialization
* [**Digest**](https://github.com/Hipbyte/Flow/tree/master/flow/digest) - Digest cryptography
* [**Store**](https://github.com/Hipbyte/Flow/tree/master/flow/store) - Key-value store
* [**Base64**](https://github.com/Hipbyte/Flow/tree/master/flow/base64) - Base64 encoding/decoding
* [**Location**](https://github.com/Hipbyte/Flow/tree/master/flow/location) - Location management and (reverse) geocoding
* [**Task**](https://github.com/Hipbyte/Flow/tree/master/flow/task) - Lightweight tasks scheduler

### Installation

`motion-flow` requires RubyMotion >= 4.12. Make sure [iOS](http://www.rubymotion.com/developers/guides/manuals/cocoa/getting-started/) and [Android](http://www.rubymotion.com/developers/guides/manuals/android/getting-started/) are correctly setup.

```
$ gem install motion-flow
```

### Projects

#### Flow projects

Flow comes with its own RubyMotion template, which creates a hybrid (iOS + Android + OS X) project.

```
$ motion create --template=flow Hello
$ cd Hello
$ rake -T
```

#### RubyMotion projects

Flow can be added as a dependency of an existing iOS, Android or OS X RubyMotion project, by adding the `motion-flow` gem in the project's `Gemfile`.

### Code organization

Each Flow library is contained in subdirectories inside the `flow` directory.
Platform-specific code is contained inside subdirectories of each library
(E.g.  `cocoa` and `android`).

### Documentation

The documentation is written separately in the `doc.rb` file. If you work on a PR,
please modify this file accordingly.

#### Generate documentation

```
yard
```
