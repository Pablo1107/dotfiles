{ ... }:

{
  getDotfile = ref: path:
    let
      localPath = ../config/. + "/${ref}/${path}";
    in
    builtins.readFile localPath;
}
