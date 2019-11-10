+++
title = "Compound primary keys and NHibernate event listeners"
tags = ["NHibernate"]
categories = ["Programming", "Databases"]
date = 2019-11-07T19:44:41.140Z
+++

Recently I had to write some code to log CUD operations done via
NHibernate. The requirement was to log the following:

 - The type of operation (insert, update, delete)
 - The primary key property name(s) and value(s) of the entity being
   operated on
 - For updates, the property name(s) and the old and new values

It was pretty straightforward apart from retrieving the primary key. If
the key is a [scalar](http://foldoc.org/scalar) then it's pretty
straightforward:

```cs
public void OnPostInsert(PostInsertEvent @event)
{
    string entityName = @event.Entity.GetType().Name;
    string entityIdPropertyName = @event.Persister.IdentifierPropertyName ?? "ID";
    string entityIdValue = @event.Id.ToString();
}
```

Unfortunately it's not at all straightforward how you're supposed to do
this when the entity/table uses a compound primary key. I eventually
came up with the following:

```cs
if (@event.Persister.IdentifierType is NHibernate.Type.EmbeddedComponentType identifierType)
{
    // This entity has a composite primary key.

    foreach (var propertyName in identifierType.PropertyNames)
    {
        // Because we only have the name of the property we have to use reflection to get
        // the corresponding value.
        object propertyValue = @event.Id.GetType().GetProperty(propertyName).GetValue(entityId);
    }
}
```
