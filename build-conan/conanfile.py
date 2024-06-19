from conan import ConanFile


class CompressorRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "MesonToolchain", "PkgConfigDeps"
    
    def requirements(self):
        # secondary deps:
        self.requires("xkbcommon/1.6.0")
        self.requires("libglvnd/1.7.0")
        self.requires("xorg/system")

        self.requires("sdl/2.30.3", override=True) # override for sdlttf
        self.requires("sdl_ttf/2.22.0")
        self.requires("glew/2.2.0")
        self.requires("openal-soft/1.23.1")

    def configure(self):
        # TODO: try to disable pulse/alsa in sdl
        self.options["sdl"].alsa = False
        self.options["sdl"].pulse = False

        self.options["sdl"].shared = True
        self.options["sdl_ttf"].shared = True
        self.options["glew"].shared = True
        # self.options["glew"].with_egl = True

        self.options["xkbcommon"].shared = True
        self.options["xkbcommon"].with_wayland = False

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
