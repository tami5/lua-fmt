{
  inputs.nixlua.url = "path:///Users/tami5/repos/nix/nixlua";
  outputs = { self, nixlua }:
    nixlua.mkOutputs (pkgs:
      with pkgs; rec {
        pname = "fmt";
        defaultVersion = "lua5_4";
        version = "master";
        build = lua: prev: {
          src = ./.;
          buildInputs = [ ];
          nativeBuildInputs = [ ];
          propagatedBuildInputs = [ ];
          buildPhase = with stdenv;
            if isDarwin then
              "$CC -o fmt.so -O3 -fPIC -shared -undefined dynamic_lookup lfmt.c"
            else
              "$CC -o fmt.so -O3 -fPIC -shared lfmt.c" "\n\n";
          installPhase = ''
            TARGET="$out/lib/lua/${lua.lua.luaversion}"
            mkdir -p $TARGET
            cp ${pname}.so $TARGET
          '';
          # FIXME
          # checkPhase = ''
          #   # ${lua.bin} -e 'print(require"${pname}"("{}", "hello"))'
          # '';
          # doCheck = true;
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
      });
}
