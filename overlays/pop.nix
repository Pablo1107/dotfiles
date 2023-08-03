self: pkgs:

{
  pop = pkgs.pop.override rec {
    buildGoModule = args: pkgs.buildGoModule ( args // {
      version = "0.2.0";
      src = pkgs.fetchFromGitHub {
        owner = "charmbracelet";
        repo = "pop";
        rev = "v0.2.0";
        sha256 = "1yg3vwrya0bix7y2n0njd6g2g2x18mqxic2mnznhs8s4mnjn8qk4";
      };
      vendorSha256 = "1pz44hdr96g7r7zwrskmhdk9gpdqg84f3ysk7vyx4wblyig0k1zi";
      ldflags = [ "-s" "-w" "-X=main.Version=0.2.0" ];
    }); };
}
