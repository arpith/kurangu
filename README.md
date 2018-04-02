# kurangu
Runtime type collection for Ruby

## Installation
`gem install kurangu`

## Usage
`kurangu input.rb` where `input.rb` is the file you want annotations for 😊

By default, Kurangu generates annotations for files in the same directory as the input file.

## How It Works
Kurangu uses [TracePoints](http://ruby-doc.org/core-2.5.0/TracePoint.html) to listen to method calls and returns, and to collect the runtime types for the arguments and return values.

Then, using the method’s parameter information, it creates signatures for each call and updates the annotations file. The signatures are used to create an [intersection type](https://github.com/plum-umd/rdl#intersection-types) for the type checker.
