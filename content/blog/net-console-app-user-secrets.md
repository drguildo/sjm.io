+++
title = ".NET Console App User Secrets"
date = 2022-04-20T19:35:35+01:00
+++

When scaffolding an EF Core .NET 6 console app recently, I discovered the it
doesn't support sourcing connection strings from the user secrets store unless
you're scaffolding an ASP.NET project. A lot of the documentation on the web,
both from Microsoft and third-parties, also seems to assume that you're using
ASP.NET.

Here's how I got it working with the minimum of fuss.

Create a user secrets store and add your secrets to it:


```
dotnet user-secrets init
dotnet user-secrets set ConnectionStrings:Foo ...
dotnet user-secrets set SomeApiKey ...
```

Install the requisite package for adding user secrets support to
`ConfigurationBuilder`:

`dotnet add package Microsoft.Extensions.Configuration.UserSecrets`

Add the `ConfigurationBuilder` call to your code, and use it to fetch your user
secrets:

```cs
var config = new ConfigurationBuilder()
    .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
    .AddUserSecrets<Program>()
    .Build();
string fooConnectionString = config.GetConnectionString("Foo");
string someApiKey = config.GetSection("SomeApiKey").Value;
```

In the case of the connections string, update your `DbContext` constructor(s) to
take it as a parameter:

```cs
public FooContext(string connectionString)
{
    _connectionString = connectionString;
}

protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
{
    if (!optionsBuilder.IsConfigured)
    {
        optionsBuilder.UseSqlServer(_connectionString);
    }
}
```

That's it!
