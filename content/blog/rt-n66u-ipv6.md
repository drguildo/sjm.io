+++
title = "ASUS RT-N66U IPv6"
date = "2017-10-17T16:32:45+01:00"
description = "Getting IPv6 working with the ASUS RT-N66U and Aquiss."
+++

I'm using an [ASUS RT-N66U](https://www.asus.com/uk/Networking/RTN66U/)
and my ISP is [Aquiss](http://aquiss.net/) (an
[Entanet](http://aquiss.net/) reseller). I wanted to get IPv6 working.

After a little bit of fiddling, the following settings seem to have done
the trick:

```text
Connection type: Native
Interface: PPP
DHCP-PD: Enable

Auto Configuration Setting: Stateless

Connect to DNS Server automatically: Enable

Enable Router Advertisement: Enable
```

Hope this helps anybody else in the same situation.
