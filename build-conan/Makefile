.PHONY: *
default:

clean:
	rm -rf deps build

conanexport:
	conan export conan-recipes/libglvnd/system --version system --user customwoy
	conan export conan-recipes/xorg/all --version system --user customwoy
	conan export conan-recipes/sdl/all --version 2.30.3 --user customwoy

conaninstall:
	conan install . --output-folder=deps --build=missing

mesonsetup:
	meson setup --reconfigure --prefix=$(CURDIR)/build --native-file deps/conan_meson_native.ini build

compile:
	meson compile -C build

install:
	meson install -C build

linux-package:
	TMPDIR=$$(mktemp -d) &&\
	PROROOT=$$PWD &&\
	./patchElfShared.sh &&\
	cp build/bin/* "$$TMPDIR" &&\
	cp -av deps/libs/* "$$TMPDIR" &&\
	cd "$$TMPDIR" && tar -czvf "$$PROROOT/linux.tar.gz" * &&\
	rm -r "$$TMPDIR"

windows-package:
	TMPDIR=$$(mktemp -d) &&\
	PROROOT=$$PWD &&\
	cp build/bin/* "$$TMPDIR" &&\
	cp -av deps/libs/* "$$TMPDIR" &&\
	cd "$$TMPDIR" && 7z a -r "$$PROROOT/windows.zip" &&\
	rm -r "$$TMPDIR"

# Compatibility

conaninstallnix:
	conan install . --output-folder=deps --build=missing -pr:a=conan-profiles/nixprofile

conaninstallzig:
	conan install . --output-folder=deps --build=missing -pr:a=conan-profiles/zigprofile -vvv

mesonsetupvs:
	meson setup --reconfigure --prefix=$(CURDIR)/build --native-file deps/conan_meson_native.ini build --vsenv

# Debugging

conanrun:
	. ./deps/conanrun.sh; cd build && ./example

rebuildSdl:
	./conan-recipes/update-recipes.sh
	$(MAKE) conanexportnix
	$(MAKE) conaninstallnix
	conan install . --output-folder=deps --build=sdl/*@customwoy -pr:a=conan-profiles/nixprofile

conanGraphNix:
	conan graph info . --format=html -pr:a=conan-profiles/nixprofile > graph.html
