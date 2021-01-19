with (import <nixpkgs> { overlays = [(self: super: { ruby = super.ruby_2_7; })]; config.allowUnfree = true; });
let
  env = bundlerEnv {
    name = "untitledgame-bundler-env";
    inherit ruby;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
    gemdir   = ./.;
    gemConfig = pkgs.defaultGemConfig // {
      ruby-sdl2 = attrs: {
        buildInputs = [ SDL2 ];
      };
    };
  };
in stdenv.mkDerivation rec {
  name = "untitledgame";

  src = builtins.filterSource
    (path: type:
      type != "directory" ||
      baseNameOf path != "vendor" &&
      baseNameOf path != ".git" &&
      baseNameOf path != ".bundle")
    ./.;

  buildInputs = [
    env.wrappedRuby bundler bundix git sqlite SDL2
  ];
}
