# Swarker [![Build Status][BS img]][Build Status] [![Gem Version][GV img]][Gem Version] [![Code Climate][CC img]][Code Climate]

Converts [lurker][lurker] schemas to [swagger][swagger] schema

## Thanks

<a href="https://evilmartians.com/?utm_source=swarker">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'swarker', require: false
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swarker

## Usage

To convert you lurker schemas just run `swarker convert`. By default it expects to find schemas in `lurker` directory
and store swagge schema to `public`:

```
$ swarker convert
```

You can easily define input and output directory for your choice:

```
$ swarker convert -i lurker_path -o output_path
```

Also you can filter lurker endpoints by it's path subtree:

```
$ swarker convert -s lurker/api/v2
```

To familiarize with other options just start with:

```
$ swarker help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can 
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sponomarev/swarker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[Build Status]: https://travis-ci.org/sponomarev/swarker
[BS img]: https://travis-ci.org/sponomarev/swarker.svg
[Gem Version]: https://badge.fury.io/rb/swarker
[GV img]: https://badge.fury.io/rb/swarker.svg
[Code Climate]: https://codeclimate.com/github/sponomarev/swarker
[CC img]: https://codeclimate.com/github/sponomarev/swarker/badges/gpa.svg

[lurker]: https://github.com/razum2um/lurker/
[swagger]: https://github.com/swagger-api/swagger-spec
