# Atom Packages Directory - Documentation

## Requirements

* RethinkDB (2.3.1 or later)
* Ruby (2.2.3 or later)
* NodeJS for Bower (1.7.9 or later)

## Dependencies

Since the backend is written in Ruby, the dependencies for the backend are installed via [Bundler](http://bundler.io/):

```shell
$ bundle install
```

The fronted uses [Bower](http://bower.io/) and can be installed via:

```shell
$ bower install
```

## Bootstrapping

To get everything started, you'll need to grab some data from http://atom.io, but there is a convenient way to do that.

```shell
$ rake site:bootstrap
```

This task will download all available packages, parse the downloaded JSON, import the pakcages into the database and create the categories set in `config.yml`.

## Starting the application

Once all requirements are met, all dependencies are installed and the site has been bootstrapped, you can start the server with:

```shell
$ puma
```

And the site should be available under http://localhost:9292 in your browser.
