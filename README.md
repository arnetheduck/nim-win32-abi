# nim-win32-abi

Nim bindings for the full Win32 API, [generated](https://github.com/arnetheduck/nim-winmd)
from WinMD metadata and headers.

These bindings expose the raw `C` API with minimal curation - they can either
be used directly or as a base for a higher-level binding.

## Usage

The bindings have no dependencies outside of Nim and Windows themselves.

You can copy files selectively to your project or use nimble:

```nim
requires "win32_abi"
```

### Layout

Each Nim module corresponds to a Win32 SDK header:

* `win32/abi/<header>.nim` — one module per originating header (e.g. `windef`,
  `winbase`, `processthreadsapi`)
* `win32_abi.nimble` — package manifest.

For example [`CreateWindowExA`](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexa)
can be found in `win32/abi/winuser`.

### dynlib

The bindings currently use `dynlib` to gain access to the Windows API -
this is not a great way to link to the windows libraries and this will likely
change in the future.

In the meantime it is recommended that you add
[`dynlibOverride`](https://nim-lang.org/docs/nimc.html#dynliboverride)
for each `dll` file that you end up needing.

Here's a starting point that you can copy-paste to `config.nims` to the top-level
directory of your project - these are the libraries that linkers typically link
by default anyway:

```nim
# These libraries are implicitly linked by llvm-mingw
const defaultLibs = ["gdi32", "comdlg32", "advapi32", "shell32", "user32", "kernel32"]
for lib in defaultLibs:
  switch("dynlibOverride", lib) # disable dynlib runtime code

# Other libraries need explicit linking as well
const otherLibs = ["otherlib"]
for lib in otherLibs:
  switch("dynlibOverride", lib) # disable dynlib
  switch("clib", lib) # link the library at compile time
```

### winlean

If you were using `winlean` before, you will need to make a few adjustments:

* `win32_abi` uses Win32 spelling
  - `winlean` uses a mix of nim and Win32 conventions
* `win32_abi` uses the Win32 types as declared in `C`
  - `winlean` uses a mix of types of its own devising with different signedness
    or type altogether (ie `int` vs `uint`, `int32` vs `uint32`, `int` vs
    `pointer` etc)
  - `winlean` uses _casts_ to hide the mismatch which may or may not be what
    you want
* `win32_abi` splits the Windows API into modules based on how the Windows SDK has evolved
  into distinct header files
  - `winlean` instead exposes a subset of the older `windows.h` + `WIN32_MEAN_AND_LEAN`
    approach
* `win32_abi` exposes both `A` and `W` variants where the SDK does so
  - `winlean` only exposes `W` variants and uses `WideCString` which has several
    bugs / issues at the time of writing
  - `A` versions are used in modern windows applications targeting
    [UTF-8](https://learn.microsoft.com/en-us/windows/apps/design/globalizing/use-utf8-code-page)

## Generation

* [`nim-winmd`](https://github.com/arnetheduck/nim-winmd) — WinMD
  (ECMA-335) reader library and the `winmd2nim` binding generator
* [`windows-rs`](https://github.com/microsoft/windows-rs/) - Microsoft's own
  binding generator (for Rust) - provides `Windows.Win32.winmd` and the header
  mappings
* [SOURCE.env](./SOURCE.env) - git hashes of the binding sources used to create
  the bindings
* `nim-win32-abi` — the generated result

## Related projects

* [winim](https://github.com/khchen/winim) - high-level bindings that might be easier to use
* [win32metadata](https://github.com/microsoft/win32metadata) - similar bindings for other languages