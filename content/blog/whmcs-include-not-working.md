+++
title = "WHMCS Smarty {include} Not Working"
date = 2017-09-11T16:54:49+01:00
description = "Fix for WHMCS Smarty template {include} not working."
+++

I've been using [Smarty](https://www.smarty.net/) templates a bit recently while
working with [WHMCS](https://www.whmcs.com/) and ran into an issue. When trying
to do `{include 'some_template.tpl'}`, I was getting no output. Smarty seemed
to just stop all processing at that point. The fix was maddeningly simple,
especially as I'd tried a bunch of different variations of absolute and
relative paths.

If your template is in a file called `some_template.tpl`, you need to use:

```php
{include './some_template.tpl'}
```

In the case of WHMCS, templates are stored in a directory called templates, but
you don't need to specify that as part of the path.
