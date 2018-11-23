+++
title = "WHMCS 500 Error"
description = "Diagnosing WHMCS 500 errors."
date = 2017-09-01T15:47:33+01:00
categories = ["Software"]
tags = ["WHMCS", "Apache", "XAMPP", "PHP"]
+++

While working on an addon module for [WHMCS](https://www.whmcs.com/) I
kept getting a generic [500 error code](https://httpstatuses.com/500)
and a blank page. I was pretty sure it was a problem in my code but
there was nothing in the [XAMPP](https://www.apachefriends.org/)
`error.log` or the WHMCS admin dashboards so I had no way of tracking
down the cause.

I managed to finally track down the cause by enabling the __Display
Errors__ option under __Setup__ → __General Settings__ → __Other__.
