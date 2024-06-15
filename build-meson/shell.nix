with import <nixpkgs> {};

llvmPackages.stdenv.mkDerivation {
	name = "clang-build-env";
	buildInputs = [
        # libs
        SDL2
        SDL2_ttf
        glew
        openal
        # build tools
        meson
        ninja
        pkg-config
        # extra tools
        cacert # for downloading meson modules through SSL
		busybox
		git
	];
	shellHook = ''
		# git prompt
		source ${git}/share/git/contrib/completion/git-prompt.sh
		PS1='\[\033[0;33m\]nix:\w\[\033[0m\] $(__git_ps1 %s)\n$ '
	'';
    # To compile with Zig:
    # CC="zig cc" CXX="zig c++" AR="zig ar" OBJCOPY="zig objcopy" make
}
