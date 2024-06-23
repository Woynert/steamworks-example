# Building

## Ubuntu or derivatives build

setup:

```
apt install gcc g++ make cmake pipx python3.8-venv pkg-config ninja-build
pipx install meson && pipx install conan
```

setup conan:

```
conan profile detect
make conanexport
conan install . --output-folder=deps --build=missing -c tools.system.package_manager:mode=install -c tools.system.package_manager:sudo=True
```

compile:

```
make mesonsetup
make compile
```

run:

```
make conanrun
```

## Pure Nix build

Note that this isn't 100% reproducible because of Conan. For a more reproducible setup see the Nix file at `/build-meson`.

build:

```
make conanexport
make conaninstallnix
make mesonsetup
make compile
```

run:

```
cd build && steam-run ./example
or
LD_LIBRARY_PATH=/nix/store/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-pulseaudio/lib make conanrun
```

## Docker / Podman build (glibc 2.31)

build:

```
cd docker
docker compose up
```

run:

```
cd build
./example
or
LD_LIBRARY_PATH=/path/to/conan-build/deps/libs:$LD_LIBRARY_PATH ./example
```

# Conan dependencies info

## Linux (Clang compiler)

* libglvnd/system
    Why use system provided version?:
    * Already provided by most distros, no need to recompile.
    * Better compatibility because different distros may configure/compile/patch it differently.
* xorg/system
    * Required to be from system, xorg/x11 shouldn't be static [citation needed].
    * Submit a patch to Conan to correctly set the cflags and include directories.
* xkbcommon
* sdl
    * Some patches required
* sdl_ttf
* glew
* openal-soft
    * Requires system pulseaudio (libpulse.so) to be available in LD_LIBRARY_PATH.

## Linux (Zig compiler)

Currently some libs cannot be compiled with Zig, for these, compile as shared using Clang or use system provided libs.
Fortunately these are already available in default Ubuntu instalations: (xorg, libglvnd, xkbcommon)
