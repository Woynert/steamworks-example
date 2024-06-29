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
        if self.settings.os == "Linux":
            self.requires("libglvnd/system@customwoy", override=True) # from glew: use custom recipe for system version
            self.requires("xorg/system") # from sdl
            self.requires("xkbcommon/1.6.0") # from sdl

    def configure(self):
        self.options["sdl"].shared = True
        self.options["sdl_ttf"].shared = True
        self.options["glew"].shared = True
        # self.options["glew"].with_egl = True

        if self.settings.os == "Linux":
            self.options["sdl"].alsa = False
            self.options["sdl"].pulse = False
            self.options["xkbcommon"].shared = True
            self.options["xkbcommon"].with_wayland = False

    def generate(self):
        # gather all shared libs for release
        deps_to_copy = ["sdl", "sdl_ttf", "glew"]
        if self.settings.os == "Linux":
            deps_to_copy += ["xkbcommon"]
            lib_pattern = "*.so*"
            for dep in deps_to_copy:
                copy(self, lib_pattern, src=self.dependencies[dep].cpp_info.libdir, dst="libs")
            return;
        lib_pattern = "*.dll"
        for dep in deps_to_copy:
            copy(self, lib_pattern, src=self.dependencies[dep].cpp_info.bindir, dst="libs")
