+++
title = "Wayback Machine Bookmarklet"
date = 2021-10-21T18:42:48+01:00
+++

I've come up with the following bookmarklet for searching the Internet Archive's
fantastic Wayback Machine for the current URL and thought I'd share it.

I found an existing bookmarklet that purported to do this, but it included the
protocol scheme (the e.g. `http://` part) in the lookup string, which meant it
didn't work. I'm not a fan of the regular expressions, but this was more
succinct than constructing the lookup string via the
[Location](https://developer.mozilla.org/en-US/docs/Web/API/Location) object
provided by the browser.

```javascript
javascript:void(location.href='https://web.archive.org/web/*/'+escape(location.href.replace(/^https?:\/\//, '').replace(/\/$/, '')));
```
