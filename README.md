# Flow

<img src="flow-logo.png" alt="flow logo" width="300">

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
* [**Store**](https://github.com/jjaffeux/Flow/tree/master/flow/store) - Key-value store
* [**Base64**](https://github.com/jjaffeux/Flow/tree/master/flow/base64) - Base64 encoding/decoding

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

## License

Copyright (c) 2015, HipByte (info@hipbyte.com) and contributors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
