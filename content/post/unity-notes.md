+++
title = "Unity Notes"
date = "2018-02-10T12:09:01Z"
draft = true
tags = ["Unity", "Game Development"]
categories = ["Programming", "Game Development"]
description = "A collection of notes I've made while learning about the Unity game engine."
+++

GameObject
----------

```cs
Instantiate(GameObject prefab);
Instantiate(GameObject prefab, Transform parent);
Instantiate(GameObject prefab, Vector3 position, Quaternion rotation);
```

Component
---------

Transform
---------

```cs
transform.Translate();
```

Input
-----

```cs
Input.GetKey(KeyCode.Space)
Input.GetKeyDown(KeyCode.Space)
Input.GetKeyUp(KeyCode.Space)

Input.GetAxis("Horizontal")
Input.GetAxisRaw("Horizontal")
```

Time
----

```cs
GameObject gameObject;
gameObject = GameObject.Find("Foo");
gameObject = GameObject.FindGameObjectsWithTag("Foo");

gameObject = FindObjectOfType<Player>();
```

Physics
-------

Collision Detection

Coroutines
----------

```cs
yield
StartCoroutine();
StopCoroutine();
IEnumerator
```
