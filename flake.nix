{
  inputs.nixlua = "path://Users/tami5/repos/nix/nixlua";
  outputs = { nixlua }:
    nixlua.mkOutputs (pkgs:
      with pkgs; rec {
        pname = "fmt";
        defaultVersion = "lua5_4";
        version = "master";
        build = lua: prev: {
          buildInputs = [ ];
          nativeBuildInputs = [ ];
          propagatedBuildInputs = [ ];
          buildPhase = with stdenv;
            if isDarwin then
              "gcc -o fmt.so -O3 -fPIC -shared -undefined dynamic_lookup lfmt.c"
            else
              "gcc -o fmt.so -O3 -fPIC -shared lfmt.c" "\n\n";
          installPhase = ''
            TARGET="$out/lib/lua/${lua.lua.luaversion}"
            mkdir -p $TARGET
            cp ${pname}.so $TARGET
          '';
          checkPhase = ''
            MSG=${lua} -e 'require"${pname}"("{}", "hello")'
            [[ $MSG = "hello" ]]
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
      });
}
