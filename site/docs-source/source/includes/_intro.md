# Introduction

*Web Development Using a Distributed, Concurrent Lisp*

[![][dragon-logo]][dragon-logo-large]

[dragon-logo]: images/dragon-logo-2-200px.png
[dragon-logo-large]: images/dragon-logo-2-200px.png


## About Dragon

For a long time, LFE didn't have a web framework. Anyone doing web just rolled whatever they needed using YAWS or Cowboy and libraries from the BEAM ecosystem. This is a pretty standard approach in the Erlang world, and arguably a habit that could do more to embrace new users.

With the massive growth of the Elixir community, many of whom have backgrounds in Ruby, Python, etc., the expectations have changed around providing developers with go-to solutions. In particular, the Elixir community has produced the extremely popular [Phoenix Framework](http://www.phoenixframework.org/) for web development. Members of the LFE community have been singing its praises and asking for something similar.

In the world of mythology, a natural and amicable complement to the Phoenix is the Dragon. The LFE web development project chose this name to deliberately emphasize this.  Due to the fact that both Elixir and LFE are BEAM languages, one can use the Phoenix framework with LFE. However, some LFE devs would prefer to not only use a web framework, but hack on one as well -- doing both in LFE. Dragon is for them. It is this level of flexibility that we see the frameworks complementing each other.

Dragon's philosophy is oriented towards collections of libraries. This approach derives from that of the lmug collection of libraries ([lmug](https://github.com/lfex/lmug), 2014) which in turn was inspired by Clojure's take on [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface): [Ring](https://github.com/ring-clojure/ring/blob/master/SPEC). In this same spirit, Dragon makes no demands on how you do things -- it simply offers a collection of libraries, example usage, deployment advice, and lots of Lisp.

For a tongue-in-cheek overview of the Dragon philosophy, see the [Dragon Manifesto](#the-dragon-manifesto).


## What You Get

Version 0 of Dragon ships with YAWS, [lfest]() (routes), [exemplar]() (S-expression-based XML and HTML), [mnemosyne]() (Nosql) , [ljson](), and [logjam](). As such, you have all the tools necessary to build simple web applications.


### Components

Some of the libraries mentioned above touch upon the conceptual components of a Dragon application. These are as follows:

* **HTTPD** - An OTP web server, complete with supervision tree and heartbeat support. This functionality is currently fulfilled only by YAWS.
* **Routing** - A URL-based dispatch mechanism for web application resources (equally applicable to REST servers)
* **Content** - Creating HTML and other response-ready content via S-expressions
* **Data** - Storing and retrieving data in an Erlang-native (batteries-included) Nosql database

How each of things gets done is up to the developer. We do provide examples and may eventually offer some best practices guides, but we don't impose implementation details around these. If you want to include messaging, you can either use the built-in capabilities of Erlang and LFE processes, or you can add RabbitMQ as a dependency for your system. Your data access code, your "business logic", and your "display" or "rendering logic" should all be loosely coupled, but you may do this in whatever way you see fit.


### What's Coming

In future releases of Dragon, we will

* Provide the ability to easily use static HTML and HTML fragments (in either file or string form) in conjunction with S-expression-based output
* Provide additional, non-Mnesia Nosql integration
* Provide SQL/ACID integration
* Begin pulling in not only code Ring-like and WSGI-like functionality (think of these as "feature composition")
* Add best-of-breed community middleware and functionality
* Include support for aadditional web servers -- your v1 Dragon code won't have to change when you change web servers (though there will be a migration path from v0 Dragon to v1).

Stay tuned!


## Documentation

The Dragon documentation provided here is currently in progress. The content is organized along the following lines:

* Project Overview/Introduction (what you're reading)
* Getting Started
* Tutorial
* The Dragon Manifesto

This will eventually mature into sections with a user guide, more tutorials, operators manual (e.g., deployment guides) and the like.


## Doc Conventions

We use styled call-outs to provide immediate visual cues about the nature of
the information being shared.

These are as follows:

<aside class="info">
This style indicates useful information, background, or other insights.
</aside>

<aside class="success">
This style indicates a best practice, good usage, and other tips for success.
</aside>

<aside class="caution">
This style indicates one should use caution or that behaviour may not be as
expected
</aside>

<aside class="danger">
This style indicates information that could cause errors if ignored.
</aside>
