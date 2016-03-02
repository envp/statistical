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

## Workflow / General Guidelines
1. Fork this repository and create your feature branch
2. All new code addition must be through the feature branch only. Changes to master will be rejected.
3. Test your on code atleast 3 continuous major releases of ruby (you can setup travis-CI for this). Usually CURRENT_RUBY_VERSION and two major predecessors should be fine (2.3.X, 2.2.Y 2.1.W)
4. Try to keep one commit per change (Optional, but better to be organized)
5. If possible write a test case which confirms your change
6. When submitting a change that chooses a specific algorithm over others available write your rationale behind the choice. Benchmarks comparing different algorithms would be highly appreciated.
7. Yes, it's OK to pick an algorithm for simplicity of expression.
8. Your pull request should attempt to explain the change you want to introduce

## Coding conventions

How to style your C and Ruby code which you want to submit.

### C code

Please note the following hints for your C code:

#### Comply with C99 (ISO/IEC 9899:1999)

This library should be portable to other systems and compilers. For this it is
recommended to keep your code as close as possible to the C99 standard
(http://www.open-std.org/jtc1/sc22/WG14/www/docs/n1256.pdf).

As some of us may also be using Visual C++ as a build target. For this reason a
declaration of a local variable has to be at the beginning of a scope block.

#### Reduce library dependencies to a minimum

The dependencies to libraries should be kept to an absolute minimum. If this is
not possible immediately, consider authoring a secondary gem for this that lives 
under statistical-<feature_name>. This can also be added as a plugin.

#### Don't use C++ style comments

    /* This is the preferred comment style */

Use C++ style comments only for temporary comments e.g. commenting out some code lines.

#### Insert a break after the method return value:

    int
    main(void)
    {
      ...
    }

### Ruby code

`bundle exec rake cop` is your best friend here.

## Notes
Feel free to open a "question" issue if you have any questions or want to discuss about better ways to go about this.