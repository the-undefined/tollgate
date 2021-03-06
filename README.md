[![Build Status](https://travis-ci.org/the-undefined/tollgate.svg?branch=master)](https://travis-ci.org/the-undefined/tollgate)

# Tollgate

Have you paid your code toll? To get your code into the groomed and uniform metropolis where the static analyser enforcers run the place, then you need to put extra effort and pay the code toll before you are allowed through.
Invest in a better future!

Making it easy to add static code analysers to your workflow. Build a list of shell commands to execute and check your code locally and on your CI server.

All checks need to pass before the tollgate approves the code, if any of the checks fail then a non-zero exit status will be returned, so if using on a CI server then the build will fail.

## Quickstart

Add the gem to your project:

```rb
group :development, :test do
  gem "tollgate", require: false
end
```

Define a configuration file at `config/tollgate_config.rb` and use the `check` method for any of the command line tools you want to run on your project:

```rb
Tollgate.configure do
  check "rubocop"
  check "brakeman"
  check "rspec"
end
```

Then use the `tollgate` command to run your commands:

```sh
$ tollgate
# ... output from commands being check

PASS: rubocop
PASS: brakeman
FAIL rspec
```

## Grouping Commands

Sometimes you may want several checks to run regardless if one of them has failed, so that you can make related changes before running the tollgate again.

For instance `rubocop` and `standard` check for Ruby and JavaScript code styles and it makes sense for you to get the output of both of these at the same time.
Whereas `rubocop` and `rspec` are not related in their information, so by grouping `rubocop` and `standard` you can fix the style changes together before running the tollgate again to get the output from `rspec`:

```rb
Tollgate.configure do
  group :styles do
    check "standard | snazzy"
    check "rubocop"
  end
  
  check "rspec"
end
```

```sh
$ tollgate
# ... output from checks being run

FAIL: standard | snazzy
PASS: rubocop
NOT RUN: rspec
```

You do not need to specify a group name if you can't think of one, naming things is hard(!), and you can specify as many groups as you like:

```rb
Tollgate.configure do
  group do
    check "rubocop"
    check "standard | snazzy"
  end

  group do
    check "brakeman"
    check "rails_best_practices"
  end

  check "rspec"
  check "cucumber"
end
```
In the example above, if the first group fails then the second group will not be run, nor will any checks that come later in the list, the output would look like:

```sh
# ...

FAIL: rubocop
PASS: standard | snazzy
NOT RUN: brakeman
NOT RUN: rails_best_practices
NOT RUN: rspec
NOT RUN: cucumber

Tollgate failed.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Tollgate is setup to run on itself under which you can invoke using the `bin/test` script to check for ruby styles and run tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb` and tag the commit with the save version, when the build passes on master then Travis will release the new version of the gem to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/the-undefined/tollgate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Tollgate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/the-undefined/tollgate/blob/master/CODE_OF_CONDUCT.md).

## License

This project uses an unlicense, all code is in the public domain, see LICENSE.md for more details.
