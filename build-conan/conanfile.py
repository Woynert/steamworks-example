from conan import ConanFile
from conan.tools.files import copy



class CompressorRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "MesonToolchain", "PkgConfigDeps"
    
    def requirements(self):
        # main
        self.requires("sdl/2.30.3", override=True) # override for sdlttf
        self.requires("sdl_ttf/2.22.0")
        self.requires("glew/2.2.0")
        self.requires("openal-soft/1.23.1")

        # secondary
        self.requires("libglvnd/system@customwoy", override=True) # from glew: use custom recipe for system version
        self.requires("xorg/system") # from sdl
        self.requires("xkbcommon/1.6.0") # from sdl

    def configure(self):
        self.options["sdl"].alsa = False
        self.options["sdl"].pulse = False

        self.options["sdl"].shared = True
        self.options["sdl_ttf"].shared = True
        self.options["glew"].shared = True
        # self.options["glew"].with_egl = True

        self.options["xkbcommon"].shared = True
        self.options["xkbcommon"].with_wayland = False

    def generate(self):
        # gather all shared libs for release
        deps_to_copy = ["sdl", "sdl_ttf", "glew", "xkbcommon"]
        for dep in deps_to_copy:
            copy(self, "*.so*", src=self.dependencies[dep].cpp_info.libdir, dst="libs")

# NOTES:
# * when a dep is marked as override, but no other dep uses it, it gets discarded
# * xkbcommon could be skipped since supposedly should already be available on Ubuntu
# * could use system cmake
# * make minimum reproduction project:
#   * libFoo depends on libBar
#   * profile overrides libBar with system version
#   * libTee depends on libFoo
#   * Error: libTee can't find libBar because a bug when using system override?
# * make minimum reproduction project (updated):
#   * libFoo depends on libBar
#   * libFoo uses self.cpp_info["compFoo"].requires.append("libBar::compBar")
#   * profile overrides libBar with system version
#   * Error: libTee can't find libBar because a bug when using system override?
# * PR to conan index: expat requires cmake
# * PR to conan index: brotli requires cmake
# * PR to conan index: libglvnd requires a system version since it doesn't work in Ubuntu
