ASSIGNMENT
Backend Challenge

- We want you to build a REST API (Ruby on Rails preferred). It will allow users to submit IP addresses. 
- You will fetch the country/city from GeoJS and store them in server memory cache. 
- A second end point should allow users to see all IP addresses tracked, and the data associated with it. 
- The user should also be able to filter all IP addresses by country/city.
- The IP addresses and their data don't need to be persisted to a database. 
- Also the API should return JSON.


DESIGN NOTES
------------

CONTROLLERS
- I like to distinguish between internal API calls and calls we want to expose as official API calls,
so, I have put the GeoController inside a 'module API' and created two endpoints:

  GET /api/geo: given an IPv4, it will return the associated geographic info using GeoJS.
  GET /api/ips: returns a list of all IP addresses and associated data; can be filtered.


DATABASE/MODELS
- None for this prototype.


CACHING
I had a simple cache implementation based on Redis and wanted to use that. But one
of the project requirements was to return everything in the cache (all IP's) and
I didn't see an easy way for Redis to do this; we'd have to get all the keys and look up the
values one by one. I didn't want to spend any more time and decided to use a global hash instead.


ERROR CHECKING
I wanted to include some and one place I could think of was when the IP address is submitted.
The check I have is a quick and dirty one that ensures we have an IPv4 formatted address.


FILTERING BEHAVIOR
In looking at the data coming back from GeoJS I noticed that some locations don't have a city. This 
means when a city filter is in place, those entries will be excluded.


CERTIFICATE ISSUES
- RestClient::SSLCertificateNotVerified
I ran into this issue in /lib/geo_js.rb and the best solution is to have actual certificates in place. 
One of the fastest ways of doing this is to have self-signed certs, but that didn't work. So I had to
made a comprimise and verify SSL only when in production mode (on Heroku).


TESTING
These are the things I wanted to test:
0. Application healthcheck
1. Correctness of geo data being returned.
2. Correct caching behavior.
3. Correct filtering behavior for "GET /api/ips?city=chicago", etc.

Potential issues:
a. There's a clean way to test API's in rspec using webmock that I'm not familiar with and didn't have time to look into.
b. In testing the correct caching behavior, I'd have to have a way of finding out if an actual API was being
made to GeoJS in order to get the data. This would require either changing the return values or setting some
global flags.

