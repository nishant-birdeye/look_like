# look_like matcher [![Build Status](https://travis-ci.org/nishants/look_like.svg?branch=master)](https://travis-ci.org/nishants/look_like) [![Coverage Status](https://coveralls.io/repos/github/nishants/look_like/badge.svg?branch=master)](https://coveralls.io/github/nishants/look_like?branch=master) [![Gem Version](https://badge.fury.io/rb/look_like.svg)](https://badge.fury.io/rb/look_like)

- This gem is a collection of rspec matchers, for writing wireframe tests.
- Such tests search for visual clues for detecting presence of a bug.
- Useful for writing sanity tests in higher environments, e.g. testing your fresh deploy to production.
- These can reuse your code for regression tests.  
- Meaningful assertion reports help in quick diagnosis of faults. 
- For example you can write test for fresh deployments to make sure the currency and language are correct by domain/user. 
- [Try online] (http://amoeba.social/lab/look-like/)

## Installation

- Add this line to your application's Gemfile:
```ruby
gem 'look_like'
```

- To your spec_helper/test_helper or env.rb for cucumber, add following : 
```ruby
require "look_like"
```


- And then execute:
```bash
$ bundle install
```

## Usage
```ruby
actual   = [["one@two.xyz"  ,  "₹300,20", "yes"],
            ["two@three.com",  "₹301,20", "no" ],
            ["one@two.xyz"  ,  "₹121,20", ""   ]]
            
expected = [["email", "₹amount", "yes/no*"]]

expect(actual).to look_like(expected)  
```

[Try online here](http://amoeba.social/lab/look-like/index.html#/Rows)
## Custom Matchers
```ruby

LookLike::Matchers.define({
  :name     => :my_custom_matcher,
  :desc     => "my custom matcher",
  :select   => lambda{|expected|
     # return true if this matcher must be used for given expectation.
  },
  :match    => lambda{|actual, expected|
     # return true if actual matches expected
  } 
})
```
[Examples for defining matchers] (https://github.com/nishants/look_like/tree/master/lib/look_like/matchers).


## Writing Wireframe Tests with Cucumber
- Suppose this is how an html table look like :

| Name       | Email         | Commission | Enrolled | HomePage                                      |
|------------|---------------|------------|----------|-----------------------------------------------|
| User One   | user1@abc.com | $5,008.00  | yes      | https://www.facebook.com/profile.php?id=76273 |
| User Two   | user2@abc.com | $493.00    | no       |                                               |
| User Three | user3@abc.com | $8.00      | yes      | https://www.facebook.com/profile.php?id=76273 |

- In your feature file, define the table rows   
```gherkin
Scenario: View employees detail table
  Given I am an admin
  Then  I should see employees table like
        |name      |email     |  $amount  | yes/no | url* |
```

- In your steps, get table rows as array of array
```ruby
Then(/^I should see employees table like$/) do |definition|
  rows = homepage.open.employee_table_rows
  expect(rows).to look_like(definition.rows)
end
```

## List of Matchers
- [**Email**] (http://amoeba.social/lab/look-like/#/Email)
```ruby
expect("one@two.xyz").to look_like("email")
expect("one@two.xyz").to look_like("a@b.com")
```

- [**Amount and Currency**](http://amoeba.social/lab/look-like/#/Amount%20and%20Currency)
```ruby
expect("$53,23,1").to look_like("$amount")
expect("₹23,1.00").to look_like("₹amount")

expect("$53,23,1").to look_like("$12.21")
expect("₹23,1.00").to look_like("₹100.12")
```

- [**Enums**](http://amoeba.social/lab/look-like/#/Enums)
```ruby
expect("one").to look_like("one/two/three")
expect("four").not_to look_like("one/two/three")
```

- [**Regex**](http://amoeba.social/lab/look-like/#/Regex)
```ruby
expect("1-12-1-2").to look_like("/[\\d\\-]+/")
expect("$3.67").to look_like("/\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/")
expect("$367").not_to look_like("/\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/")
```

- [**URL**](http://amoeba.social/lab/look-like/#/URL)
```ruby
expect("google.com").to look_like("http://google.com")
expect("http://google.com").to look_like("http://google.com")
expect("google-com").not_to look_like("http://google.com")
```

- [**Wildcard**](http://amoeba.social/lab/look-like/#/Wildcard)
```ruby
expect("").to look_like("email*")
expect("not.an.email").not_to look_like("email*")
expect("one@two.xyz").to look_like("email*")

expect("one@two.xyz").to look_like("a@b.com*")

expect("").to look_like("*")
expect("any-thing").to look_like("*")
```

- [**Numbers**](http://amoeba.social/lab/look-like/#/Numbers)
```ruby
expect("5000").to look_like("number")
expect("5,000").to look_like("number")
expect("5,43.11").to look_like("number")

expect("6993").to look_like("5000")
expect("5000").to look_like("5,000")
expect("$5000").not_to look_like("5000")
```

- [**Date and Time**](http://amoeba.social/lab/look-like/#/Date%20and%20Time)
```ruby
expect("12/13/2014").to look_like("date")
expect("12/13/2014").to look_like("DD/MM/YYYY")
expect("06/21/1987").to look_like("12/13/2014")

expect("1994-11-05T08:15:30-05:00").to look_like("timestamp")
expect("2014-12-31 T 11:59:13").to look_like("YYYY-MM-DD T HH:MM:SS")
expect("2014-12-31 T 11:59:13").to look_like("YYYY-MM-DD T hh:mm:ss")
expect("1994-11-05T08:15:30-05:00").to look_like("2011-02-05T18:23:30-05:00")

```

- [**Arrays**](http://amoeba.social/lab/look-like/index.html#/Arrays)
```ruby
actual   = ["one@two.xyz",  "₹300,20", ""]
expected = ["email"      , "₹amount" , "*"]
expect(actual).to look_like(expected)
```

- [**Rows**](http://amoeba.social/lab/look-like/index.html#/Rows)
```ruby
actual   = [["one@two.xyz"  ,  "₹300,20", "yes"],
            ["two@three.com",  "₹301,20", "no" ],
            ["one@two.xyz"  ,  "₹121,20", ""   ]]
expected = [["email", "₹amount", "yes/no*"]]

expect(actual).to look_like(expected)
```


## Development
- After checking out the repo, run `bin/setup` to install dependencies. 
- Then, run `rake spec` to run the tests. 
- You can also run `bin/console` for an interactive prompt that will allow you to experiment.
- To install this gem locally, run `bundle exec rake install`. 
- To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`
- Release task  will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
- Build report : https://travis-ci.org/nishants/look_like
- Coverage report : https://coveralls.io/github/nishants/look_like

## Contributing
- Report bugs or suggest improvements at https://github.com/nishants/look_like/issues.
- Pull requests are highly welcome at at https://github.com/nishants/look_like. 

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

