[![Build Status](https://travis-ci.org/HipByte/Flow.svg?branch=master)](https://travis-ci.org/HipByte/Flow)

# Flow

<img src="flow-logo.png" alt="flow logo" width="300">

Flow is a set of cross-platform libraries for RubyMotion. It can be seen as RubyMotion's missing standard library.

Each library implements the following requirements:

* Simple Ruby API
* 100% cross-platform (iOS, Android and OS X)
* No external dependencies
* Covered by tests
* Documented

**WARNING**: Flow is currently a work in progress. Some specs might be broken and APIs might change. If you want to help please get in touch.

## Libraries

Flow is currently composed of the following libraries:

* [**Net**](https://github.com/jjaffeux/Flow/tree/master/flow/net) - HTTP networking and host reachability
* [**JSON**](https://github.com/jjaffeux/Flow/tree/master/flow/json) - JSON serialization
* [**Digest**](https://github.com/jjaffeux/Flow/tree/master/flow/digest) - Digest cryptography
* [**Store**](https://github.com/jjaffeux/Flow/tree/master/flow/store) - Key-value store
* [**Base64**](https://github.com/jjaffeux/Flow/tree/master/flow/base64) - Base64 encoding/decoding
* [**Location**](https://github.com/jjaffeux/Flow/tree/master/flow/location) - Location management and (reverse) geocoding
* [**Task**](https://github.com/jjaffeux/Flow/tree/master/flow/task) - Lightweight tasks scheduler

## Usage

### Installing

Flow comes as a gem.

```
$ sudo gem install motion-flow
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

Flow can be added as a dependency of an existing iOS, Android or OS X RubyMotion project, by adding the `motion-flow` gem in the project's `Gemfile` assuming Bundler is being used.  If Bundler is not being used, Flow can be added as a dependency by adding `require 'motion-flow'` to the project's `Rakefile`.

## License

Copyright (c) 2015, HipByte (info@hipbyte.com) and contributors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
