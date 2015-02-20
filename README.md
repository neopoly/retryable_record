[github]: https://github.com/neopoly/retryable_record
[doc]: http://rubydoc.info/github/neopoly/retryable_record/master/file/README.md
[gem]: https://rubygems.org/gems/retryable_record
[travis]: https://travis-ci.org/neopoly/retryable_record
[codeclimate]: https://codeclimate.com/github/neopoly/retryable_record
[inchpages]: https://inch-ci.org/github/neopoly/retryable_record

# retryable_record

[![Travis](https://img.shields.io/travis/neopoly/retryable_record.svg?branch=master)][travis]
[![Gem Version](https://img.shields.io/gem/v/retryable_record.svg)][gem]
[![Code Climate](https://img.shields.io/codeclimate/github/neopoly/retryable_record.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/neopoly/retryable_record/badges/coverage.svg)][codeclimate]
[![Inline docs](https://inch-ci.org/github/neopoly/retryable_record.svg?branch=master&style=flat)][inchpages]

[Gem][gem] |
[Source][github] |
[Documentation][doc]

Retries an operation on an ActiveRecord until no StaleObjectError is being
raised.

## Usage

You can use `retryable_record` in 3 different ways:

### Module function

```ruby
require 'retryable_record'

RetryableRecord.retry(user) do
  user.username = "foo"
  user.save!
end
```

### Kernel import

```ruby
require 'retryable_record/import'

RetryableRecord(user) do
  user.username = "foo"
  user.save!
end
```

### Module inclusion

```ruby
require 'retryable_record'

class User < ActiveRecord::Base
  include RetryableRecord
end

user = User.first

user.retryable do
  user.username = "foo"
  user.save!
end
```

## Option `attempts`

There is also an option `attempts` to limit the number of retries. If no
attempts option is specified, it's assumed to be possibly infinte attempts
until  an ActiveRecord::StaleObjectError is not raised. The `attempts` option
works in all three forms.

Here is the Module inclusion example with an attempts option used.

```ruby
require 'retryable_record'

class User < ActiveRecord::Base
  include RetryableRecord
end

user = User.first

user.retryable(:attempts => 5) do
  user.username = "foo"
  user.save!
end
```

After 5 attempts, this will just re-raise the ActiveRecord::StaleObjectError
anyway.

## Optimistic locking (lock_version column)

ActiveRecord migration needs to support optimistic locking. See
http://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :lock_version

      t.timestamps
    end
  end
end
```

## Credits

Inspired by
* http://blog.codefront.net/2008/01/14/retrying-code-blocks-in-ruby-on-exceptions-whatever/
* http://github.com/nfedyashev/retryable
* http://vision-media.ca/resources/ruby/better-ruby-retryable-method (broken)


### Contributors

Thanks to all contributions from awesome
[people](https://github.com/neopoly/retryable_record/contributors)!

## TODO

* Improve README example
* Add Changelog!
* Intergration test with ActiveRecord


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future
  version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to
  have your own version, that is fine but bump version in a commit by itself
  I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

