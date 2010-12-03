Panmind Usage Tracker
---------------------

What is it?
===========

 1. A `Rack::Middleware` that sends selected parts of the request environment to an UDP socket
 2. An `EventMachine` daemon that opens an UDP socket and sends out received data to CouchDB
 3. A set of CouchDB map-reduce views, for analysis


Does it work?
=============

Yes, but the release is still incomplete, because currently tests are too
tied to Panmind logic.

If you can help in complete the test suite, it is much appreciated :-).

Deploying
=========

 * Add the usage_tracker gem to your Gemfile and require the middleware

   gem 'usage_tracker', :require => 'usage_tracker/middleware'

 * Add the Middleware to your application:

    Your::Application.config.middleware.use UsageTracker::Middleware

 * The daemon can be started manually with the following command, inside a Rails.root:

     $ usage_tracker [environment]

   `environment` is optional and will default to "development" if no command line
   option nor the RAILS_ENV environment variable are set.

   or can be put under Upstart using the provided configuration file located in
   `config/panmind_usage_tracker.conf`.

   The daemon logs to `log/usage_tracker.log` and rotates its logs when receives
   the USR1 signal.

 * The daemon writes its pid into tmp/pids/usage_tracker.pid

 * The daemon connects to a Couch database named `usage_tracker` running on `localhost`,
   default port `5984/TCP`, and listens on `localhost`, port `5985/UDP` by default.
   You can change these settings via a `config/usage_tracker.yml` file. See the example
   in the `config` directory of the gem distribution.

 * The CouchDB instance must be running, the database is created (and updated)
   if necessary.

 * If the daemon cannot start, e.g. because of unavailable database or listening
   address, it will print a diagnostig message to STDERR, log to usage_tracker.log
   and exit with status of 1.

 * The daemon exits gracefully if it receives the INT or the TERM signals.

Testing
=======

The current test suite, brutally extracted from Panmind codebase, is in the
`middleware_test.rb` file at the root of the Gem distribution. It is of no
use except Panmind, but it's a start for writing new ones. Please help! :-)
