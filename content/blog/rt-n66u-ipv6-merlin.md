+++
title = "ASUS RT-N66U IPv6 with Merlin"
date = "2019-06-09T18:28:57+01:00"
description = "Getting IPv6 working with the ASUS RT-N66U running the unofficial Merlin firmware and Aquiss/Entanet."
+++

In a [previous post]({{<ref "/blog/rt-n66u-ipv6.md">}}) I described how to get
IPv6 working on the ASUS RT-N66U using the stock firmware. I've since switched
to using the unofficial [Merlin](https://asuswrt.lostrealm.ca/) firmware.

While the settings in the previous article still apply, Merlin has more settings
exposed and, at least in my case, failing to change the *Prefix Length* from
the default *64* to *56* left IPv6 in a broken state. This led to various
network issues such as avatars in the Twitter app taking forever to load, Steam
being dog-slow on my Ubuntu 18.10 laptop etc.

Here are my current settings:

```text
Connection type: Native
Interface: PPP
DHCP-PD: Enable
MTU: 1280

LAN Prefix Length: 56
Auto Configuration Setting: Stateless
Lifetime (sec): 86400

Connect to DNS Server automatically: Enable
Advertise router as IPv6 DNS server: Yes
Enable name resolution for fixed addresses: No

Enable Router Advertisement: Enable
Enable DHCPv6 Server: Enable

Enable IPv6 MTU advertisement: Yes
Release addresses on exit: Yes
Prefix delegation requires address request: No
```
