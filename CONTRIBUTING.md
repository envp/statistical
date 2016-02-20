# Adding a new distribution
run `bundle exec bin/distribution -n <dist_name>` from the project root to add boilerplate code for the distribution class, rng class and specs.

## Structure
The gem is split into random number generators and the abstract probabilty distributions that these generators draw from.

To add an RNG for a distribution in `statistical/lib/rng` a class with the same name must be defined under `statistical/lib/distribution` under the `Distribution` module

`rng.rb` and `distribution.rb` provide useful constants to list all the subclassed distributions, and act as a factory layer on top of all distributions in 

All abstractions of distributions must be under the module `Statistical::Distribution`

All random number generators must be under the module `Statistical::Rng`

## Useful rake tasks
The default `rake` task is to run the tests
* `bundle exec rake spec` - Run rspec tests
* `bundle exec rake cop` - Run rubocop
* `bundle exec rake doc` - Run yard to generate documentation


## Roadmap
* Implementations of all common distributions mentioned in the NIST [engineering and statistics handbook](http://www.itl.nist.gov/div898/handbook/eda/section3/eda366.htm)
* Add a module `Statistical::Hypothesis` which allows for statistical hypothesis testing

## Notes
Feel free to open a "question" issue if you have any questions or want to discuss about better ways to go about this.