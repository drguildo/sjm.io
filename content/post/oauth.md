+++
title = "OAuth for the Confused"
description = "A guide to OAuth 1.0a."
date = 2017-08-28T12:13:41+01:00
categories = ["Tutorials", "Programming"]
tags = ["OAuth", "Authentication", "HTTP"]
+++

While working on some code recently I ended up learning far more about
OAuth than I ever wanted to know and so I thought I'd share my pain with
the Internet.

This guide will cover [OAuth 1.0a](https://oauth.net/core/1.0a/) as
that's what I've been working with.

> OAuth is an open standard for access delegation, commonly used as a
> way for Internet users to grant websites or applications access to
> their information on other websites but without giving them the
> passwords.

So, how does it work? We're going to be covering things at a fairly high
level as the fine technical details involve cryptography and other hairy
things we probably don't want to concern ourselves with.

Before we get started we'll need a few things:

- Consumer credentials
 - A consumer key
 - A consumer secret
- Endpoints
 - A request token URL
 - An authorisation URL
 - An access token URL

The aforementioned __consumer__ is whatever is acting on behalf of the
user. For example a Twitter client posting on behalf of somebody would
be the consumer. Note that these are the credentials for authenticating
the _consumer_ and not the _user_.

The endpoints are simply the URLs that we'll be sending data back and
forth to at different stages of the process.

The process is broken down into the following steps:

1. Obtaining a __request token__
2. Authorising the request token
3. Exchanging the request token for an __access token__

# Obtaining a Request Token

The consumer uses their consumer key to identify itself to the OAuth
service using the __request token URL__, and obtains a request token.
This step is usually completely invisible to the user.

The purpose of the request token is to act as a kind of session
identifier. We're telling the OAuth service that we're about to request
authorisation on behalf of a particular user (we haven't established who
yet), and this allows the OAuth service to keep track of the process.

Now is a good time to mention signing. All token and protected resource
requests are signed using an encoded version of both the __consumer
secret__ and __token secret__ (of the request token or access token
depending on the type of request). These secrets prove ownership of the
corresponding consumer key and token.

### Example HTTP request

```text
https://oauth.example.com/RequestToken?oauth_consumer_key=CPKUYROR1TJMEWV9TUQHXOZU5WAKAR
                                      &oauth_signature_method=HMAC-SHA1
                                      &oauth_signature=JJwACKfhLCUdfxnLFWfcMyM6Uv8=
                                      &oauth_timestamp=1504007207
                                      &oauth_nonce=z02SWW
                                      &oauth_version=1.0
```

### Example HTTP response

```text
oauth_token=89HACWEFX4GABBAIUDKEB553IY8JGN&
oauth_token_secret=9JWU7NMLS6U9VOX0RFVXDDB47GI7PD&
oauth_callback_confirmed=true
```

# Authorising the Request Token

Once a request token has been obtained, the user is redirected to the
__authorisation URL__, along with the request token that was obtained in
the previous step. This is the point at which the OAuth service learns
which user it is that the consumer is acting on behalf of.

If the user isn't already, they're asked to log in and prompted to
confirm that they actually wish to give the consumer access to the
resource. This results in a __verification code__.

When we return from this step and move on to the next, the verification
code is used to prove that we're still dealing with the same user. The
verification code is passed back to the consumer using either a callback
URL provided by the consumer, or by simply displaying it and having the
user manually enter it.

### Example HTTP request

```text
https://oauth.example.com/Authorise?oauth_token=89HACWEFX4GABBAIUDKEB553IY8JGN
```

# Exchanging the Request Token for an Access Token

Using the consumer key, the request token and the verification code
obtained in the previous steps, the consumer can verify who it is, who
it's acting on behalf of and prove that it has permission to do so. This
information is sent to the __access token URL__ and a new token is
returned. This is the access token and replaces the previously issued
request token. The access token is used whenever the consumer is making
requests on behalf of the user that require authentication.

### Example HTTP request

```text
https://oauth.example.com/AccessToken?oauth_consumer_key=CPKUYROR1TJMEWV9TUQHXOZU5WAKAR
                                     &oauth_token=89HACWEFX4GABBAIUDKEB553IY8JGN
                                     &oauth_signature_method=HMAC-SHA1
                                     &oauth_signature=T3xcIXZ/jkt58zIZ4uY4GfVfIQ2=
                                     &oauth_timestamp=1504007484
                                     &oauth_nonce=Nq9eTg
                                     &oauth_version=1.0
                                     &oauth_verifier=4538794
```

### Example HTTP response

```text
oauth_token=SI96O7T9WQX4RTW8N7XTS3DMEXWGUF&
oauth_token_secret=HJSMH4X3M2WZFMYCIG1763TM8KM5BJ&
oauth_expires_in=1800
```

Congratulations, you just did OAuth. If you want to find out more then
I'd recommend reading the [OAuth 1.0a
specification](https://oauth.net/core/1.0a/); it's not bad as far as
specs go.
