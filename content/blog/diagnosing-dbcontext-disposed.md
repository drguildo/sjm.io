+++
title = "Diagnosing DbContext disposed InvalidOperationException"
date = 2025-02-19T19:37:58Z
+++

While working on a large project that uses the unit of work pattern (and other
things that generally make it harder to debug), I was getting an
InvalidOperationException with an error about the DbContext being disposed.

It wasn't obvious where this was happening, so I came up with the following:

```cs
using System.Diagnostics;

namespace My.Cool.Project
{
    internal class CustomDbContext : MyActualDbContext
    {
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                Debug.WriteLine("Disposing CustomDbContext");
            }
            base.Dispose(disposing);
        }
    }
}
```

Replace your DbContext with the above like this:

```cs
public UnitOfWork() : this(new CustomDbContext())
{
}

internal UnitOfWork(CustomDbContext context)
{
    this.Session = context;
}
```

Breakpoint the `Debug.WriteLine()` call and whenever your DbContext gets
disposed, you'll get a stack trace allowing you to see where it's getting
disposed.
