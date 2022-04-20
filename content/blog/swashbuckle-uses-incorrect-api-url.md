+++
title = "Swashbuckle generates incorrect Swagger API URL"
date = 2020-01-16
+++

I recently encountered an issue while using
[Swashbuckle](https://github.com/domaindrivendev/Swashbuckle.AspNetCore) whereby
everything would work fine when running it locally but the deployed version
would use incorrect API URLs.

`https://server.example.net/app/foo/bar?a=123`

would become

`https://server.example.net/foo/bar?a=123`

The issue seems to be caused by the fact that `server.example.net` is an API
gateway. This seems to prevent Swashbuckle from correctly inferring the URL of
the ASP.NET Core app and so it doesn't generate the
[server](https://swagger.io/specification/#serverObject) part of the schema. This
results in API requests (i.e. `/foo/bar?a=123`) getting sent to the root of the
server.

I fixed the issue by adding the following to my `Startup.cs`:

```cs
public static void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseSwagger(options => options.PreSerializeFilters.Add((swagger, httpReq) =>
    {
        if (httpReq.Host.Host == "server.example.net")
        {
            swagger.Servers = new List<OpenApiServer> { new OpenApiServer { Url = "/app" } };
        }
    }));
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("swagger/v1/swagger.json", API_NAME);
        options.RoutePrefix = string.Empty;
    });
}
```

Swagger UI should then be available at `https://server.example.net/app/` and the
correct API URL should get used.
