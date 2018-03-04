# Tollgate

Making it easy to add static code analysers to your workflow.
Build a tollgate of commands to check locally and on your CI server.

For a successfull tollgate check all the commands will return a zero exit code,
if any of the commands return a non-zero exit code then the tollgate will also
return a non-zero exit code, which when used on CI will fail the build.

## Quickstart

Add the gem to your project:

```rb
group :development do
  gem "tollgate", require: false
end
```

Define a configuration file at `config/tollgate.rb`

```rb
Tollgate.config do
  check "rubocop"
  check "brakeman"
  check "rspec"
end
```

Then use the `tollgate` command to run your tollgate:

```sh
$ tollgate
# ... output from commands being check

PASS: rubocop
PASS: brakeman
FAIL rspec
```

## Grouping Commands

Sometimes you may want several commands to run regardless if one of them has failed,
so that you can make related changes before running the tollgate again.

For instance `rubocop` and `standard` are commands that check for Ruby and JavaScript
code styles and make sense for you to get the output of both of these at the same time.
Whereas `rubocop` and `rspec` are not related in their information, and running a test
suite takes longer, so you would probably like to get the tollgate to fail early so
that you can fix the style changes before running the tollgate again.

```rb
Tollgate.config do
  group :styles do
    check "rubocop"
    check "standard | snazzy"
  end
  
  check "rspec"
end
```

```sh
$ tollgate
# ... output from commands being run

PASS: rubocop
FAIL: standard | snazzy
NOT RUN: rspec
```

You do not need to specify a group name if you can't think of one, (naming things is hard!),
and you can specify as many as you like:

```rb
Tollgate.config do
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
In the example above, if the first group fails then the second group will not be run, nor will
any `check` commands that come later in the list or commands, the output would look like:

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
