# Pipeline

Making it easy to add static code analysers to your workflow.
Build a pipeline of commands to run locally and on your CI server.

For a successfull pipeline run all the commands will return a zero exit code,
if any of the commands return a non-zero exit code then the pipeline will also
return a non-zero exit code, which when used on CI will fail the build.

**NOTE:**
Readme Driven Development underway, some of this code may not be implemented yet - check back soon for a release.

## Quickstart

Add the gem to your project:

```rb
group :development do
  gem "pipeline", require: false
end
```

Define a configuration file at `config/pipeline.rb`

```rb
Pipeline.config do
  run "rubocop"
  run "brakeman"
  run "rspec"
end
```

Then use the `pipeline` command to run your pipeline:

```sh
$ pipeline
# ... output from commands being run

PASS: rubocop
PASS: brakeman
FAIL rspec
```

## Grouping Commands

Sometimes you may want several commands to run regardless if one of them has failed,
so that you can make related changes before running the pipeline again.

For instance `rubocop` and `standard` are commands that check for Ruby and JavaScript
code styles and make sense for you to get the output of both of these at the same time.
Whereas `rubocop` and `rspec` are not related in their information, and running a test
suite takes longer, so you would probably like to get the pipeline to fail early so
that you can fix the style changes before running the pipeline again.

```rb
Pipeline.config do
  group :styles do
    run "rubocop"
    run "standard | snazzy"
  end
  
  run "rspec"
end
```

```sh
$ pipeline
# ... output from commands being run

PASS: rubocop
FAIL: standard | snazzy
NOT RUN: rspec
```

## Local VS CI

Maybe you don't want the whole test suite to run locally in your pipeline but on CI you do. You can define a callable object which returns a boolean value, and then use this as a predicate in the `run` command:

```rb
Pipeline.config do
  local -> { ENV['CI'].nil? }

  run "rubocop"
  run "brakeman"
  run "rspec", local: false
end
```

Predicates also work on groups:
```rb
Pipeline.config do
  local -> { ENV['CI'].nil? }

  run "rubocop"   # style check
  run "brakeman"  # security check
  
  group :test_suites, local: false do
    run "rspec"
    run "cucumber"
  end
end
```

### Meta

You may be tempted to added comments to each line to give people glancing over the file information on what each command does:

```rb
Pipeline.config do
  run "rubocop"   # ruby styles
  run "brakeman"  # security check
  run "rspec"     # test suite
end
```

However, there is the optional `meta` keyword that you can use for this information instead, which will be used as part of the output summary:

```
Pipeline.config do
  run "rubocop", meta: "ruby styles"
  run "brakeman", meta: "security check"
  run "rspec", meta: "test suite"
end
```

```sh
$ pipeline
# ... output from commands being run

PASS: ruby styles
PASS: security check
FAIL: test suite
      command: "rspec"
```

Failed commands with meta data will show the command name underneath for easier diagnosing.

## Helpful failures

Giving people autonomy also means giving them information to act by themselves. If one of the commands fail you can give them instruction to help diagnose or make it pass.
A string can be passed to the `on_fail` keyword argument, or you can add a heredoc onto the end of the `run` command:

```rb
Pipeline.config do
  group :analysers do
    run "rubocop", meta: "ruby styles", on_fail:  %(Run "rubocop -a" to autofix some of the issues)

    run "brakeman -w 1", meta: "security check" <<~ON_FAIL
      The warning level has been set to low, so a lot of false positives come through.

      If after investigating the site https://brakemanscanner.org/ you deem this as a false positive then add failing line numbers to the ignore file,
      this can be done interactively by running `brakeman -I` and following the instructions.
    ON_FAIL
  end

  run "rspec", meta: "test suite"
end
```

```sh
$ pipeline
# ... output from commands being run

FAIL: ruby styles
      command: rubocop

      Run "rubocop -a" to autofix some of the issues

FAIL: security check
      command: "brakeman -w 1"

      The warning level has been set to low, so a lot of false positives come through.

      If after investigating the site https://brakemanscanner.org/ you deem this as a false positive then add failing line numbers to the ignore file,
      this can be done interactively by running `brakeman -I` and following the instructions.
```
