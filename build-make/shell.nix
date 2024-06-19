with import <nixpkgs> {};

# Steamworks example requires c++11
llvmPackages.stdenv.mkDerivation {
	name = "clang-build-env";
	buildInputs = [
        # tools
        pkg-config
        busybox
        git
        lf
        # libs
        glew # Brings OpenGL, Makes OpenGL functions easily accesible
        openal
		SDL2
        SDL2_ttf
	];
	shellHook = ''
		# git prompt
		source ${git}/share/git/contrib/completion/git-prompt.sh
		PS1='\[\033[0;33m\]nix:\w\[\033[0m\] $(__git_ps1 %s)\n$ '
	'';
}
