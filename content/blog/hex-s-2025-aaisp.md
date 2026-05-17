+++
title = "MikroTik hEX S (2025) AAISP Configuration"
date = 2026-05-16T17:17:08+01:00
+++

In my never-ending quest to screw up my Internet connection, I bought a
[MikroTik hEX S (2025)](https://mikrotik.com/product/hex_s_2025), otherwise
known by the slightly less catchy "E60iUGS".

I used to have a
[RB2011UiAS-2HnD-IN](https://mikrotik.com/product/RB2011UiAS-2HnD-IN) which
generally served me well, except the WiFi on it was well past its prime, so I
bought some TP-Link Deco X55s. When they work, they're alright; the trouble is
they don't work a lot more often than I'd like. they went through a phase where
they'd constantly lose connection to each other, but that seems to have been
fixed (I assume) with a firmware upgrade. Speaking of firmware upgrades,
upgrading the firmware on them was always a nerve-racking experience as they'd
always display the red-blinking-light-of-doom for a few minutes afterwards, even
though eventually things would settle down. Combined with the fact that the
settings are also extremely limited and you have to manage them via an app, I am
not a fan of them. They've now been relegated to access points, and the hEX S is
doing all the good stuff.

With the RB2011UiAS-2HnD-IN, 99% of the configuration was achieved using
MikroTik's Quick Set feature. This allows you to select a use case from a
drop-down, and fill in some settings from a much, much smaller set than you'd be
presented with in RouterOS. Unfortunately, and bizarrely, there's only one entry
in the hEX S's drop-down: "Ethernet". All my attempts to use it to configure the
device as a router for my home LAN were met with failure. Luckily I was able to
use the config from the old RB2011UiAS-2HnD-IN, combined with some tweaks, to
get up and running.

Included below is the resulting configuration, exported using RouterOS's handy
`/export` command. It's important to note that _I've only included the settings
that diverge from the default configuration_. By default the hEX S should come
with things like `192.168.88.1/24` configured as the router's IP address,
`ether1` configured as the WAN port with the remaining Ethernet ports bridged, a
DHCP server on the bridged ports, etc.

I use [Andrews & Arnold Ltd](https://aa.net.uk/) as my ISP, but it should be
easy enough to adapt this to any other ISP that uses a PPPoE connection.

```
/interface pppoe-client
add add-default-route=yes comment="Andrews & Arnold Ltd" disabled=no \
    interface=ether1 name=aaisp password=[YOUR PASSWORD] use-peer-dns=yes user=\
    [YOUR USERNAME]
/interface list member
add interface=aaisp list=WAN
/ip upnp
set enabled=yes
/ip upnp interfaces
add interface=bridge type=internal
add interface=aaisp type=external
/ipv6 address
add from-pool=pool-ipv6-aaisp interface=bridge
/ipv6 dhcp-client
add add-default-route=yes interface=aaisp pool-name=pool-ipv6-aaisp request=\
    address,prefix
/system ntp client
set enabled=yes
/system ntp client servers
add address=time.aa.net.uk
```
