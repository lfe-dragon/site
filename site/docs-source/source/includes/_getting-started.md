# Getting Started

## Overview

This section lists the software and details the concepts needed in order to start using Dragon. Note that in this 0.0 "release" of Dragon, you will essentially be using a collection of components most actively used by LFE projects that create web sites or web services. These are not currently "branded" as being part of the Dragon project -- that will come in the next release of Dragon.


## Prerequisites

To use Dragon, you will need to have the following installed and running (if applicable) on your system:

* Developer tools such as ``gcc``, ``make``, ``autoconf``, etc.
* Erlang
* [rebar3](https://s3.amazonaws.com/rebar3/rebar3)
* ``libpam0g-dev`` (or the equivalent on your system)


## Project Structure

> A minimal Dragon project layout:

```
├── priv
│   ├── etc
│   │   └── yaws.conf
│   └── www
│       ├── <static files & dirs>
│       └── favicon.ico
├── rebar.config
└── src
    ├── yourapp.app.src
    ├── yourapp.lfe
    ├── app-content.lfe
    └── app-routes.lfe
```

A minimal Dragon project consists of the following:

* A project configuration file (``rebar.config``)
* An Erlang application configuration file (``app.src``)
* A YAWS configuration file (``priv/etc/yaws.conf``)
* LFE source code (entry point, routes, and content-generation)
* Static content


## Project Configuration

### ``rebar.config``

> Dragon project configuration file:

```erlang
{deps, [
   {lfe, {git, "https://github.com/rvirding/lfe.git",
         {branch, "develop"}}},
   {yaws, {git, "https://github.com/oubiwann/yaws.git",
          {branch, "rebar3-support"}}},
   {lfest, {git, "https://github.com/lfex/lfest.git",
           {tag, "0.3.0"}}},
   {exemplar, {git, "https://github.com/lfex/exemplar.git",
              {tag, "0.4.0"}}}
  ]}.

{plugins, [
   {'lfe-compile', {git, "https://github.com/lfe-rebar3/compile.git",
                   {tag, "0.4.0"}}}
  ]}.

{provider_hooks, [{pre, [{compile, {lfe, compile}}]}]}.
```

LFE projects tend to use ``rebar3`` to manage dependencies and builds, and Dragon is no
exception. A pretty simple project configuration is demonstrated to the right.

This project configuration highlights the major dependencies (some of which have other
dependencies), all of which will be automatically downloaded for you by ``rebar3``. The
dependencies and what they do are as follows:

* ``lfe`` - This is code that is Lisp Flavoured Erlang itself, upon which everything else depends
* ``yaws`` - This is the code that comprises the HTTP server
* ``lfest`` - This is the library we use for routes (URL dispatch) and generating YAWS-formatted HTTP responses
* ``exemplar`` - This is a library that generates XML/HTML from S-expressions (what we use to create page fragments, templates, etc.)


### Erlang ``app.src``

> Dragon ``app.src`` example:

```erlang
%% -*- erlang -*-
{application, yourapp,
 [
  {description, "Your Super-Great LFE+YAWS Web Application"},
  {vsn, "0.1.0"},
  {modules, [yourapp]},
  {registered, []},
  {applications, [kernel, stdlib]},
  {included_applications, []},
  {mod, {}},
  {env, []}
 ]
}.
```

All Erlang and LFE projects need to define an ``app.src`` file. Dragon expects this file
to be in the ``src`` directory for your project (it will get "compiled" to the project's
``ebin`` directory). Here is an example ``yourapp.app.src`` file:


### ``yaws.conf``

> YAWS configuration file:

```
logdir = log

<server localhost>
        port = 5099
        listen = 0.0.0.0
        appmods = </, yourapp exclude_paths favicon.ico>
        docroot = priv/www
</server>
```

> Note that if the ``log`` directory configured above doesn't exist, you will need to create it:

```
$ mkdir log
```

In addition to the project as a whole, you will need to configure YAWS to run your project. This is done with the ``priv/etc/yaws.conf`` file, as shown to the right.

The most important configuration directive there is the ``appmods`` one. This is where we tell YAWS what the entrypoint for our application is. In this case, it is the module ``yourapp``. YAWS will look in the module listed here and call its ``out/1`` function.

In this case, the output of ``yourapp:out/1`` will be served at the path ``/`` but any request to ``/favicon.ico`` will be ignored; that will instead be served from the docroot at ``priv/www``. If there were other static resources (such as image, javascript, or style sheet directories) that we wanted YAWS to ignore, we would list those with ``favicon.ico`` after the ``exclude_paths`` option.

## Application Code

### Entry Point

> Dragon entry point module:

```lisp
(defmodule yourapp
  (export all))

(defun out (arg-data)
  "This is called by YAWS when the requested URL matches the URL specified in
  the YAWS config (see ./priv/etc/yaws.conf) with the 'appmods' directive for
  the virtual host in question.

  In particular, this function is intended to handle all traffic for this
  app."
  (lfest:out-helper arg-data #'app-routes:routes/3))
```

We mentioned the application entry point above. To the right is an example of what that would look like.

As you can see, there's not much to this file. In general, you may find that to be the case, even with fairly complicated web apps -- much of the logic will very likely be organized into separate modules. Any top-level app-related code, though, will do well to live in this module.

The ``out/1`` function passes our app routes to the module where our routes are defined: ``app-routes:routes/3``. Let's take a look at that module next.


### Routes

```lisp
(defmodule app-routes
  (export all))

(include-lib "lfest/include/lfest-routes.lfe")

(defroutes
  ('GET "/"
    (lfest-html-resp:ok
      (app-content:page "Page Title" "Hello, World!"))))
```


## Creating Content

TBD

## Running the Server

TBD

## Further Reading

If you would like to see a complete example of a minimal LFE+YAWS web application,
be sure to check out this project:

* [https://github.com/lfex/lfeyawsmini](https://github.com/lfex/lfeyawsmini)

After a ``git clone``, check directory to ``lfeyawsmini`` and run ``make run``. This will download all the deps, build them, and then run the server which will be accessible at
[http://localhost:5099](http://localhost:5099).


A slightly more interesting LFE+YAWS web application is here:

* [https://github.com/lfex/lfeyawsdemo](https://github.com/lfex/lfeyawsdemo)

This demo application uses Bootstrap and a litle bit of jquery to build a themed site with dynamically generated content.

That project is the subject of the [Dragon Tutorial]()
