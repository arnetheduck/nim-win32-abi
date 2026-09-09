const defaultLibs = ["gdi32", "comdlg32", "advapi32", "shell32", "user32", "kernel32"]
for lib in defaultLibs:
  switch("dynlibOverride", lib) # disable dynlib

switch("path", "..")
