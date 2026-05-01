+++
title = "Goodbye Aquiss"
date = 2026-05-01T23:05:12+01:00
+++

By my reckoning I've been using [Aquiss](https://aquiss.net/) as my ISP for over
10 years. Needless to say, I've been pretty happy with them.

I like small ISPs because I like to think they give a shit about their
customers. At the other end of the spectrum, you have Big Tech™ companies like
Google and Cloudflare whose only motivation seems to be to get as rich and
powerful as possible by exploiting their customers and users to the maximum
extent they can get away with (and sometimes beyond).

I find myself increasingly depressed and disgusted by not just the behaviour of
Big Tech™ but, more depressingly, people's (including those running
organisations) willingness to cede more and more of their digital autonomy to
them, whether through ignorance or laziness. I've been guilty of it myself, at
least in the past. I remembered that I'd once set my router to use Cloudflare's
public DNS servers and decided to revert to Aquiss's own DNS servers.

Off I went into my router settings and set it to use the defaults provided by
Aquiss during PPP negotiation. I was confused when the primary and secondary DNS
server IPs switched to 8.8.8.8 and 1.1.1.1. Had the router got "confused" and
used some weird old settings? Nope. After a bit of digging, I found [this
post](https://community.aquiss.net/viewtopic.php?t=29). At some point during or
before 2024, they decided to silently get all their users to send all their DNS
traffic to Google and Cloudflare. Incredible.

I emailed to ask them, basically, what the fuck. This is their response:

> We do use those DNS servers as default as they are the industry standard.
> There is no leaking of traffic, every DNS server used will record traffic just
> the same.
>
> Both companies delete logs, Cloudflare in 24 hours and Google in 24-48 hours.
> Cloudflare does not log your full IP address and are independently audited to
> ensure they are complying with the retention policy. 
>
> Customers are free to use whichever DNS settings they prefer, we only ask they
> are returned to default when there are issues to assist with troubleshooting.
> This is due to the fact some DNS servers can cause issues with pages loading
> and speeds. There are no commercial DNS servers which do not involve a third
> party processing DNS traffic.

I started composing a reply asking things like what, exactly, they mean by
"industry standard" and "every DNS server used will record traffic just the
same." They clearly trust Google and Cloudflare, but I wanted to know whether
they thought all of their customers also trusted Google and Cloudflare, and how
they think their customers would feel about all their DNS traffic being given to
them.

In the end, I didn't bother sending it. Fuck it. Complaining seems increasingly
pointless in the year of our Lord 2026, so I've decided to vote with my money
and switch to an ISP that can at least be bothered to run their own
infrastructure and, hopefully, should it come down to it, not fob their
customers off with bullshit excuses. Goodbye Aquiss.
