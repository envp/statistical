# Statistical
[![Code Climate](https://codeclimate.com/github/vaibhav-y/statistical/badges/gpa.svg)](https://codeclimate.com/github/vaibhav-y/statistical)
[![Test Coverage](https://codeclimate.com/github/vaibhav-y/statistical/badges/coverage.svg)](https://codeclimate.com/github/vaibhav-y/statistical/coverage)
[![Issue Count](https://codeclimate.com/github/vaibhav-y/statistical/badges/issue_count.svg)](https://codeclimate.com/github/vaibhav-y/statistical)

Statistical distributions in ruby. This library aims to provide and enhance an API that maintains familiarity with ruby's core and stdlib.

## Usage

TODO: Write usage instructions here, see docs

### Documentation
Available [here](http://www.rubydoc.info/github/vaibhav-y/statistical/master).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for more details.


## Roadmap
### Immediate focus
* Implementations of all common distributions mentioned in the NIST [engineering and statistics handbook](http://www.itl.nist.gov/div898/handbook/eda/section3/eda366.htm)

### Long term
* Add a module `Statistical::Hypothesis` which allows for statistical hypothesis testing
* Explore creating a symbolic DSL using this library that involves manipulating random variates

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).