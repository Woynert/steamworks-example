with import <nixpkgs> {};
let

conan_last = conan.overrideAttrs(final: prev: {
  name = "conan-2.3.2";
  version = "2.3.2";
  src = fetchFromGitHub {
	owner = "conan-io";
	repo = "conan";
	rev = "refs/tags/${final.version}";
	hash = "sha256-rtLGIYU3VFYHcdS1OWdYAr4zYJ8s2c1vI2x3ou0xRK0=";
  };
  disabledTestPaths = [prev.disabledTestPaths] ++ [
	  "conans/test/functional/test_local_recipes_index.py" # requires cmake
	  "conans/test/functional/test_profile_detect_api.py" # requires /usr/bin/ldd
	  "conans/test/performance/test_large_graph.py" # it's looking for path "T:/mycache/profiles/default" ???
	  "conans/test/integration/command/runner_test.py" # requires docker
  ];
});

pkg_config_wrap = writeShellScriptBin "pkg-config" ''
  #!/usr/bin/env sh
  ${pkg-config-unwrapped}/bin/pkg-config $@ 2> /dev/null
  err=$?
  [ $err -ne 0 ] && exec ${pkg-config}/bin/pkg-config $@
  exit $err
'';

in
llvmPackages.stdenv.mkDerivation {
	name = "conan-env";
	buildInputs = [
        # build tools
        
		pkg_config_wrap # first: use wrapper
		pkg-config # second: set env vars
        cmake # for building conan deps
        meson
        ninja
        conan_last

		bison

        # extra tools (for convenience)

        cacert # for downloading meson modules through SSL
		busybox
		git
        patchelf
        pax-utils
        libtool # conan replace: compile openal-soft
		stdenv.cc.cc.lib # libstdc++.so.6 ??
		perl
        strace
		steamPackages.steam-fhsenv-without-steam.run

        # === SDL2 build deps ===

        xorg.libXcursor
        xorg.libXinerama
        xorg.libXi
        xorg.libXrandr
        mesa
        freeglut
        libGLU
        libGL
        alsa-lib
        pulseaudio
        libpulseaudio

		xkeyboard_config
		xorg.libfontenc
        xorg.libICE
        xorg.libSM
        xorg.libXaw
        xorg.libXcomposite
        xorg.libXdmcp
        xorg.libxkbfile
        xorg.libXpm
        xorg.libXres
        xorg.libXScrnSaver
        xorg.libXtst
        xorg.libXv
        xorg.libxcb # might not be needed
		xorg.xcbutil
		xorg.xcbutilwm
		xorg.xcbutilimage
		xorg.xcbutilkeysyms
		xorg.xcbutilrenderutil
		xcb-util-cursor
		libossp_uuid

		# === pulseaudio build deps ===

		glib
		gnum4
		autoconf
		automake
		libsndfile

        # === runtime system shared libraries ===

        #libxkbcommon # might not be needed
        libglvnd
        pulseaudio
	];
	shellHook = ''
		# git prompt
		source ${git}/share/git/contrib/completion/git-prompt.sh
		PS1='\[\033[0;33m\]nix:\w\[\033[0m\] $(__git_ps1 %s)\n$ '

        # SDL2 from Conan needs libpulse.so in standard location
        echo 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pulseaudio}/lib'
        #export LD_LIBRARY_PATH

        # only libGL needs to be overwritten to work with nixpkgs-unstable
		echo "source deps/conanrun.sh"
		echo 'LD_LIBRARY_PATH=${libGL}/lib/:$LD_LIBRARY_PATH ./build/example'
        #echo ${pulseaudio}
	'';
}
