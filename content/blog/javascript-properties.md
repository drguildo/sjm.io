+++
title = "JavaScript Properties for the Confused"
description = "A tutorial on JavaScript object properties."
date = 2017-05-08T16:35:03+01:00
+++

Like a lot of things related to JavaScript, the syntax and semantics of
properties can be a little tricky to wrap your head around. Hopefully
this article will serve to simplify and clarify things.

Our first step is to do away with the idea of arrays. But wait, arrays
are important, surely? Yes, but they're just conceptual baggage when it
comes to understanding properties because _arrays are also objects_.
And don't call me Shirley.

When we access an array index, we're really just accessing a property
of the array _object_. Don't believe me?

```javascript
let foo = ["a", "b", "c"];
console.log(foo[1]); // → "b"
console.log(foo["1"]); // → "b"
console.log(typeof foo); // → "object"
```

One way of thinking about a new concept is in terms of _how we use it_.
So how do we "use" properties? Well, if we want to access the `bar`
property of the `foo` object we have 2 options: `foo.bar` and
`foo["bar"]`.

You'll be pleased to hear we can do some more conceptual simplifying.
When you see the `foo.bar` object property method used, it's really just
[syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) for
the more versatile `foo["bar"]` subscripting method. Anything you can
do with the former, you can do with the latter, but not the other way
around. With the object property method we're limited to accessing
properties that are valid JavaScript variable names whereas with the
subscripting method we can use any value we want.

```javascript
let foo = {
  bar: 1,
  "baz": 2,
  "-nope": 3,
  3.14159265358979323846264338327950: 4,
  undefined: 5
};

console.log(foo.bar); // → 1
console.log(foo.baz); // → 2
console.log(foo.-nope); // → SyntaxError

console.log(foo["-nope"]); // → 3
console.log(foo[3.14159265358979323846264338327950]); // → 4
console.log(foo[undefined]); // → 5
```

The only special rule you need to bear in mind when using and thinking
about the subscripting method is that the value between the brackets
is evaluated before it's looked up in the specified object. The main
thing this means in practise is that when you enter, for example,
`foo[bar]` (note the lack of quotes), `bar` is treated as a variable
name and replaced with the value it refers to before being looked up
in `foo`.

```javascript
let foo = {
  bar: 1,
  "baz": 2,
  "-nope": 3
};
console.log(foo.baz); // → 2
console.log(foo["baz"]); // → 2

let baz = "-nope";
console.log(foo.baz); // → 2
console.log(foo[baz]); // → 3
```

And that's it! I hope you're less confused than when you started reading
this.

Love and kisses,

Simon
