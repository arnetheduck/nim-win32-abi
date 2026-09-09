# Package

version       = "0.1.0"
author        = "Jacek Sieka"
description   = "Comprehensive Win32 SDK bindings targeting the raw ABI"
license       = "MIT"
srcDir        = ""
skipDirs      = @["tests"]

# Dependencies

requires "nim >= 2.0.10"

task test, "Build and run the process info test application":
  if defined(Windows):
    exec "nim c -r -p:. tests/test_process_info.nim"
  else:
    # Non-Windows: compile check only (bindings load DLLs at runtime)
    exec "nim c --os:windows -p:. tests/test_process_info.nim"

