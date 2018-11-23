+++
title = "JavaScript Prototypes for the Confused"
description = "A tutorial on JavaScript prototype-based inheritance."
date = 2017-05-30T12:09:04+01:00
categories = ["Tutorials", "Programming"]
tags = ["JavaScript", "Prototype", "Inheritance"]
+++

Objects can have a prototype and a prototype is just another object. We
can get an object's prototype using the `Object.getPrototypeOf` method.

```javascript
Object.getPrototypeOf({}); // → {}
```

Yes, JavaScript really loves objects. It's objects all the way down.
Actually that's not completely true:

```javascript
Object.getPrototypeOf(Object.getPrototypeOf({})); // → null
```

The first call to `Object.getPrototypeOf` gave us the prototypical
object—the one that acts as the prototype for practically all
objects—and calling `Object.getPrototypeOf` on that gives us `null`.
You've got to stop somewhere, right?

Things like arrays and strings are objects too so they also have
prototypes:

```javascript
Object.getPrototypeOf(""); // → [String: '']
Object.getPrototypeOf([]); // → []
```

As you can see they have a different prototype to vanilla objects, but
this is only in the immediate sense:

```javascript
Object.getPrototypeOf(Object.getPrototypeOf("")); // → {}
Object.getPrototypeOf(Object.getPrototypeOf([])); // → {}
```

Prototypes can be seen as ancestors: an object being the descendent of
it's prototype. In the previous case an array is a descendent of the
array prototype which is a descendent of the object prototype etc.

## Why?

An object shares the properties of it's prototype so it's a convenient
way of sharing data and code between a set of similair objects.

```javascript
let proto = {
  x: 1
};

let foo = {
  y: 2
};

Object.setPrototypeOf(foo, proto);
console.log(foo.x); // → 1
```

## Constructors

The canonical way of constructing an object based on a prototype is by
defining a function. These types of functions are called _constructors_.
There's nothing particularly special about the functions themselves—but
rather how they're used. Rather than calling them like a normal
function, we use the `new` keyword. This binds uses of the `this`
keyword in the body of the function to a newly created object.

```javascript
function Constructor() {
  console.log(Object.keys(this).length);
}

// `this` is bound to the global object
Constructor(); // → 22
// `this` is bound to a newly created object
new Constructor(); // → 0
```

All user-defined functions have a `prototype` property.

```javascript
function foo() {}
console.log(foo.prototype); // → foo {}
```

This property contains an object unique to this function.

All new objects created using this function (and the `new` keyword),
have this unique object set as their prototype.

```javascript
function Constructor() {}
let foo = new Constructor();
console.log(Constructor.prototype === Object.getPrototypeOf(foo)); // → true
```

Any changes to this prototype object will be reflected in all objects
created using it.

```javascript
function Constructor() {}

let foo = new Constructor();
let bar = new Constructor();

Constructor.prototype.moo = () => console.log("Moo.");

foo.moo(); // → Moo.
bar.moo(); // → Moo.
```

I hope this article has left you less confused than when you started
reading it.

Love and kisses,

Simon
