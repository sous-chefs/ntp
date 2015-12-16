This cookbook uses a variety of testing components:
- Unit tests: [ChefSpec](https://github.com/acrmp/chefspec)
- Integration tests: [Test Kitchen](https://github.com/chef/test-kitchen)
- Chef Style lints: [Foodcritic](https://github.com/acrmp/foodcritic)
- Ruby Style lints: [Rubocop](https://github.com/bbatsov/rubocop)

# Prerequisites
To develop on this cookbook, you must have a sane Ruby 1.9+ environment. Given the nature of this installation process (and it's variance across multiple operating systems), we will leave this installation process to the user.

You must also have `bundler` installed:

```
$ gem install bundler
```

You must also have VirtualBox installed:
- [VirtualBox](https://virtualbox.org)

# Development
- Clone the git repository from GitHub:

   $ git clone git@github.com:gmiranda23/ntp.git

- Install the dependencies using bundler:

   $ bundle install

- Create a branch for your changes:

   $ git checkout -b my_bug_fix

- Make any changes
- Write tests to support those changes. It is highly recommended you write both unit and integration tests.
- Run the tests:
  - `bundle exec rake`
  - `bundle exec rake kitchen`

- Assuming the tests pass, open a Pull Request on GitHub
