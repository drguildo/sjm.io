+++
title = "Windows Services, Named Pipes and UnauthorizedAccessException"
tags = ["C#", ".NET", "Named Pipes", "Windows Services", "Access Control Lists"]
categories = ["Programming"]
date = 2020-02-14
+++

I was working on some proof-of-concept code whereby an unpriviledged client would communicate with a Windows service using [protocol buffer serialization](https://github.com/protobuf-net/protobuf-net) over a [named pipe](https://docs.microsoft.com/en-us/dotnet/standard/io/how-to-use-named-pipes-for-network-interprocess-communication). I was doing this using .NET Core 3.1 and the [Microsoft.Windows.Compatibility](https://www.nuget.org/packages/Microsoft.Windows.Compatibility/) package.

The transmission of the data between the processes worked great when I was just using two unpriviledged console apps. I started running into issues when I made the switch to a Windows service. Sending data from an unpriviledged process to a Windows service doesn't seem to work by default as Windows services run with elevated priviledges. When trying to send data from the client I'd get the following exception:

```
Unhandled exception. System.UnauthorizedAccessException: Access to the path is denied.
   at System.IO.Pipes.NamedPipeClientStream.TryConnect(Int32 timeout, CancellationToken cancellationToken)
   at System.IO.Pipes.NamedPipeClientStream.ConnectInternal(Int32 timeout, CancellationToken cancellationToken, Int32 startTime)
   at System.IO.Pipes.NamedPipeClientStream.Connect(Int32 timeout)
   at System.IO.Pipes.NamedPipeClientStream.Connect()
   at TestServerClient.Program.Main(String[] args) in Program.cs:line 26
```

After far too much searching and reading, it turns out that this is a [known issue](https://github.com/dotnet/runtime/issues/26869) with the .NET Core versions of named pipes. Apparently the access control list needs to be set via the named pipe's constructor, but there is no .NET Core `NamedPipeServerStream` constructor that takes an instance of the `PipeSecurity` class, which is responsible for named pipe ACL:

```cs
public NamedPipeServerStream(string pipeName);
public NamedPipeServerStream(string pipeName, PipeDirection direction);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances);
public NamedPipeServerStream(PipeDirection direction, bool isAsync, bool isConnected, SafePipeHandle safePipeHandle);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode, PipeOptions options);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode, PipeOptions options, int inBufferSize, int outBufferSize);
```

So you're forced to specify and ACL using the the `SetAccessControl` method, which doesn't work:

```cs
var pipeSecurity = new PipeSecurity();
pipeSecurity.AddAccessRule(new PipeAccessRule("Users", PipeAccessRights.ReadWrite, AccessControlType.Allow));
namedPipeServerStream = new NamedPipeServerStream("TestService.Pipe", PipeDirection.InOut);
namedPipeServerStream.SetAccessControl(pipeSecurity);
```

Unfortunately, the only solution that I'm aware of is to target .NET Framework, which _does_ allow the specifying of an ACL during `NamedPipeServerStream` instantiation:

```cs
var pipeSecurity = new PipeSecurity();
pipeSecurity.AddAccessRule(new PipeAccessRule("Users", PipeAccessRights.ReadWrite, AccessControlType.Allow));
namedPipeServerStream = new NamedPipeServerStream("TestService.Pipe", PipeDirection.InOut, 1, PipeTransmissionMode.Message, PipeOptions.None, 4096, 4096, pipeSecurity);
```

```cs
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode, PipeOptions options, int inBufferSize, int outBufferSize, PipeSecurity pipeSecurity);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode, PipeOptions options, int inBufferSize, int outBufferSize, PipeSecurity pipeSecurity, HandleInheritability inheritability);
public NamedPipeServerStream(string pipeName, PipeDirection direction, int maxNumberOfServerInstances, PipeTransmissionMode transmissionMode, PipeOptions options, int inBufferSize, int outBufferSize, PipeSecurity pipeSecurity, HandleInheritability inheritability, PipeAccessRights additionalAccessRights);
```
