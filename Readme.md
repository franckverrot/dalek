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
* `say <words>`: Dalek will just repeat what you told him to
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

You can access a special field called parameters to use the payload for
fun and profit:


```ruby
  on 'weather' do
    city = payload
    result = some_logic_to_get_the_weather(city)
    say result
  end
```

## How to test a plugin

TBD

## How to test Dalek itself

`rake` should start the tests.

## How to run Dalek

Dalek was made to work on Heroku's "Cedar" stack

You can run it with this command:

REDISTOGO_URL=redis://127.0.0.1:6379 CAMPFIRE_TOKEN=<token> CAMPFIRE_SUBDOMAIN=<subdomain> rake run
