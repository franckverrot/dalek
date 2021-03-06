# Dalek by Evome


## Introduction

Dalek is a Campfire bot that load plugin dynamically and use
metaprogramming to self-mutate.

[What a short self-explainatory video](http://www.youtube.com/watch?v=IvZMTtdGvi4)

## Requirements

* Ruby 1.9.2 or higher
* Bundler
* Redis

## Existing features

The real goal behind Dalek is to keep the code base very thin and work
only with modules. In order to bootstrap those plugins, some methods are
available though:

* `load http://example.com/mygist.txt`: Dalek will read the content of
  the `mygist.txt` file and execute it.
* `help`: Dalek will output a list of known commands

## How to create a plugin

Dalek provides a small Sinatra-like DSL. Let's say you have a gist like:

```ruby
  on 'foo' do
    say 'bar'
  end
```

and you load it in thru Campfire: `load http://....`

Everytime someone will type 'foo' as the first word of a message in
Campfire, Dalek will wake up and execute the body of the block. In this
very case, it will send "bar" to the Campfire room.

You can use a Regex as a parameter to extract some portions of the
payload like this:

```ruby
  on 'weather (?<location>.*)' do
    result = some_logic_to_get_the_weather_of(params[:location])
    say result
  end
```

It is planned to make things a bit easier and only have to write this:

```ruby
  on 'weather :location' do
    result = some_logic_to_get_the_weather_of(params[:location])
    say result
  end
```

Pull Requests are welcome.


## How to test a plugin

TBD

## How to test Dalek itself

`rake` should start the tests.

## How to run Dalek

Dalek was made to work on Heroku's "Cedar" stack

You can run it with this command:

REDIS_URL=redis://127.0.0.1:6379 CAMPFIRE_TOKEN=<token> CAMPFIRE_SUBDOMAIN=<subdomain> rake run
