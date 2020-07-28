# Monopoke

Welcome to Monopoké, a Ruby CLI turn-based game.  Yep, I just committed to the extra 'o' 😀

## Installation
After cloning the repository, you can run the following in your terminal to install the CLI tool:

```ruby
bundle install
gem build monopoke
gem install --local monopoke
```

## Usage
To start a game, simply type `monopoke`  followed by the path to your input file.  The sample input is saved as part of the project, under `spec/support` if you need sample data at the ready.

The game's output will print to the console, as well as to an output file (with a datestamp), which will be placed in the same path as the input file.

## Tests
To run the test suite, you can run `bundle exec rspec spec`

## Improvements
- Refactor the tests that were moved over from the original structure.
- Make it a truly turn based CLI (involves adding a database to track the gameplay)
- Add a more playful UI for the selections, using something like [Shopify's CLI UI](https://github.com/Shopify/cli-ui)
