# Base45

The Base45 module provides for the encoding (#encode) and
decoding (#decode) of binary data using a Base45 representation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'base45'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install base45

## Usage

Some simple encoding and decoding:

```ruby
require "base45"

encoded = Base45.encode("The truth is out there")
# => "8UADZCKWE8%EG7D+EDN448%ES44+8DZKE"

decoded = Base45.decode(encoded)
# => "The truth is out there"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag
for the version, push git commits and the created tag, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wattswing/base45.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Resources used

* [Base 45 Draft](https://datatracker.ietf.org/doc/draft-faltstrom-base45/)
* [A JS Base 45 implementation](http://base45-decode-encode.net/)
* [SO question](https://stackoverflow.com/questions/68114693/decode-base45-string)
