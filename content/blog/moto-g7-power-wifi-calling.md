+++
title = "WiFi Calling and the Billion 8800NL R2"
date = 2020-05-03
+++

I have a Moto G7 Power (XT1955-4) and recently switched to EE because they
support WiFi calling with that model. The trouble is, I could not for the life
of me get it working. The WiFi calling setting was enabled but whenever I'd go
to make a call, I'd get an error telling me to connect to a wireless network.
Needless to say I was connected to my WiFi and had no connectivity issues.

After a fruitless conversation with EE support and various posts on various
forums, none of which helped, it turns out that the issue was IPsec being
enabled on my Billion 8800NL R2 router. This wasn't something I enabled but
rather it was enabled by default. After disabling it and restarting the router,
WiFi calling sprung into action on my phone.

The setting is buried under __Configuration__ → __NAT__ → __ALG__.
