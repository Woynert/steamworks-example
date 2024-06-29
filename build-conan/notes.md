# NOTES:

Some Conan discrepancies I have found:

* Open issue: When a dep is marked as override, but no other dep uses it, it gets discarded
* Open issue: Make minimum reproduction project:
  * libFoo depends on libBar
  * libFoo uses self.cpp_info["compFoo"].requires.append("libBar::compBar")
  * profile overrides libBar with system version
  * Error: libTee can't find libBar because a bug when using system override?
* PR to conan index: expat requires cmake
* PR to conan index: brotli requires cmake
* PR to conan index: libglvnd requires a system version since it doesn't work in Ubuntu
