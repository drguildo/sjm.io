+++
title = "SDL2 on Windows with MSVC without Visual Studio"
date = 2021-10-18T18:31:45+01:00
+++

I've been interested in learning some low-level graphics programming and so
figured a good way to do it would be via [SDL](https://www.libsdl.org/) and C.

I already had Microsoft's C compiler available as I had a minimal (as much as
anything to do with Microsoft or Visual Studio can be called minimal) Visual
Studio Build Tools installation for [Rust](https://www.rust-lang.org/)
development, but I didn't want to have to install the bloated mess that is
Visual Studio.

I started by trying to build the small example program I found
[here](http://www.myrkraverk.com/blog/2019/07/hello-world-with-sdl2/):

```c
#include <SDL.h>

int main(int argc, char *argv[]) {
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_INFORMATION, 
                  "Hello World",
                  "You have successfully compiled and linked an SDL2"
                  " program, congratulations.", NULL);

    return 0;
}
```

with the following command line:

```text
cl /ISDL2-2.0.16\include test.c /link /LIBPATH:SDL2-2.0.16\lib\x86 /SUBSYSTEM:WINDOWS SDL2.lib SDL2main.lib
```

However, I'd get the following linker error:

```text
unresolved external symbol __imp__CommandLineToArgvW@8 referenced in function _main_getcmdline
```

After a lot of digging around, it turned out that the problem was that I was
failing to link against shell32.lib. The following command worked:

```text
cl /ISDL2-2.0.16\include test.c /link /LIBPATH:SDL2-2.0.16\lib\x86 /SUBSYSTEM:WINDOWS shell32.lib SDL2.lib SDL2main.lib
```
