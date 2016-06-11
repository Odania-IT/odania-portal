---
title: Odania Portal

---
# [Odania](http://www.odania.com)

Odania is a Portal that is designed to serve different contents for multiple domains. Every component can be scalled to
handle a huge amount of traffic.

The entry point from the web is varnish. Varnish is a web accelerator also known as caching reverse proxy. If we content
is not in the cache, varnish will ask one of the plugins. Plugins can be registered in Consul and are load balanced by
varnish.

Odania Core is a sinatra app that creates the basic layout of the page. Odania Core is running together with another varnish.
This internal varnish handles the catching of the internal pages.

## Varnish

Varnish is used as the public entry point.
We use varnish esi capability to retrieve different partials from the backends.
You can define if a request should be served from one of the modules.
As default all other requests are served by Odania Core.

[Odania Varnish](https://github.com/Odania-IT/odania-varnish)

## Consul

Consul is used to manage the services and configuration.

[Docker Consul](https://github.com/Odania-IT/docker-consul)

## [Odania Core](https://github.com/Odania-IT/odania-core)

Odania Core transforms the erb template into varnish esi templates.
It uses elasticsearch to retrieve the partials.

The api in odania core is used by the plugins to send/update the partials. They are then indexed by elasticsearch for retrieval.

## [Odania Static](https://github.com/Odania-IT/odania-static)

Odania Static is a simple plugin that servers static content. The content is created as Markdown or HTML content.
A plugin transforms the Markdown into HTML.

Redirects and directly served page configuration is stored in consul.
Partials are send to Odania Core via the api.
