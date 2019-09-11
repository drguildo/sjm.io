+++
title = "HashSet, IEquatable and Contains"
date = 2019-09-05T18:47:41+01:00
categories = ["Programming"]
tags = [".NET", "C#", "Data Structures", "Identity"]
+++

I recently came across some unintuitive and confusing (but understandable)
behaviour when dealing with `HashSet<T> where T : IEquatable`. I'd written a
class that implemented `IEquatable` based purely on the ID of the object. The
trouble was that `HashSet.Contains` was saying that it didn't contain the object
I was passing it even though it contained an object with the same ID.

Here's a trimmed-down example that exhibits the same behaviour:

```cs
class Foo : IEquatable<Foo>
{
    public int Id { get; private set; }

    public Foo(int id)
    {
        this.Id = id;
    }

    public bool Equals(Foo other)
    {
        return this.Id == other.Id;
    }
}

var l = new List<Foo> { new Foo(1) };
Console.WriteLine(l.Contains(new Foo(1))); // true
var h = new HashSet<Foo> { new Foo(1) };
Console.WriteLine(h.Contains(new Foo(1))); // false
```

The reason the second `Console.WriteLine` outputs false is because of the _hash_
part of HashSet. The `HashSet` implementation of `Contains` will first try to
retrieve the object you give it using whatever `GetHashCode` returns when called
on that object. If it doesn't find anything then `Contains` simply returns
`false`. The `List` implementation actually makes use of `Equals` to discern
whether or not the collection contains the relevant object (or rather one that
`Equals` dictates is the same object).

The trouble is that I've read in numerous places that you shouldn't override
`GetHashCode` for non-value types (objects that will change their state over
the course of their lifetime), so the options are either to ignore that advice
for non-value types or to use a data structure that doesn't rely on hash
lookups.
