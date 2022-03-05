+++
title = "DrayTek Vigor 130 and MikroTik RB2011UiAS-2HnD-IN"
date = 2022-03-05T11:43:01Z
+++

If you just want to get the damn thing working as a modem (referred to as
"[bridge mode](https://www.draytek.co.uk/support/guides/kb-vigor-130-bridge)" in
 the DrayTek documentation) with your router, but don't want to read about the
 ballache I had to go through

 - Select "Enable" on the "MPoA / Static or dynamic IP" page
 - Select "1483 Bridged IP VC-Mux" from the "Encapsulation" drop-down on the
   same page
 - Click "OK" to save and restart the "modem"

If you want to hear me have a good moan about the device, read on.

I got a DrayTek Vigor 130 to replace an old Openreach Huawei HG612, but ran into
quite a few issues trying to get it to work with my MikroTik RB2011UiAS-2HnD-IN
router, at least in it's default configuration.

The DrayTek Vigor 130 is marketed as a modem. It isn't, at least not in it's
default state. It's also marketed as simple and easy to set up and use. It
isn't.

By default it runs a DHCP server and acts as a gateway to any router you have it
connected to. If your router is configured to use a PPPoE client to actually
use the Vigor 130 as a modem, this won't work. The Vigor 130's web UI will say
it's connected, but nothing will get routed properly.

To make matters worse, if you put the 130 in "bridge mode" by enabling it on
the "MPoA / Static or dynamic IP" page, it still won't work. By default,
"Encapsulation" is set to "1483 Bridged IP LLC", which doesn't work with my ISP
([Aquiss](https://aquiss.net/) / [CityFibre](https://cityfibre.com/)), and, I
assume, most other UK VDSL ISPs. You have to change it to "1483 Bridged IP
VC-Mux" and then, hopefully, things will work as expected.
