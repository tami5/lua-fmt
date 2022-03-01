{
  inputs.nixlua.url = "github:tami5/nixlua";
  outputs = { self, nixlua }:
    let
      pname = "fmt";
      defaultVersion = "lua5_1";
      version = "master";
    in nixlua.mkOutputs rec {
      inherit self pname defaultVersion version;
      config = pkgs: {
        build = lua: prev: {
          src = ./.;
          buildInputs = [ ];
          nativeBuildInputs = [ ];
          propagatedBuildInputs = [ ];
          buildPhase = with pkgs.stdenv;
            if isDarwin then
              "$CC -o fmt.so -O3 -fPIC -shared -undefined dynamic_lookup lfmt.c"
            else
              "$CC -o fmt.so -O3 -fPIC -shared lfmt.c" "\n\n";
          installPhase = ''
            TARGET="$out/lib/lua/${lua.lua.luaversion}"
            mkdir -p $TARGET
            cp ${pname}.so $TARGET
          '';
          doCheck = false;
        };
        shell = {
          luaEnv = lua:
            with lua; {
              extra = [ stdlib ];
              path = [ "?.lua" ];
              cpath = [ "l/?.so" ];
              overrides = { };
            };
          packages = [ ];
          commands = [ ];
          env = [ ];
        };
      };
    };
}
