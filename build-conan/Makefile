default:

clean:
	\rm -rf deps build

conanexport:
	# export custom recipes
	conan export conan-recipes/libglvnd/system --version system --user customwoy
	conan export conan-recipes/xorg/all --version system --user customwoy
	conan export conan-recipes/sdl/all --version 2.30.3 --user customwoy

conaninstall:
	# build deps and export consumable build files
	conan install . --output-folder=deps --build=missing

conaninstallnix:
	conan install . --output-folder=deps --build=missing -pr:a=conan-profiles/nixprofile

conaninstallzig:
	conan install . --output-folder=deps --build=missing -pr:a=conan-profiles/zigprofile -vvv

mesonsetup:
	# consume conan dependencies
	meson setup --reconfigure --native-file deps/conan_meson_native.ini build

compile:
	meson compile -C build

conanrun:
	. ./deps/conanrun.sh; cd build && ./example

# Debugging

rebuildSdl:
	./conan-recipes/update-recipes.sh
	$(MAKE) conanexportnix
	$(MAKE) conaninstallnix
	conan install . --output-folder=deps --build=sdl/*@customwoy -pr:a=conan-profiles/nixprofile

conanGraphNix:
	conan graph info . --format=html -pr:a=conan-profiles/nixprofile > graph.html
